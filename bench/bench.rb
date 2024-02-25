# frozen_string_literal: true

require "benchmark"
require "markly"
require "qiita-markdown"
require "markdown_rustified"

markdown_text = ""
File.open("fixtures/sample.md", "r") do |f|
  markdown_text = f.read
end

# todo
class MyHtmlRenderer < Markly::Renderer::HTML
  def initialize
    super
    @header_id = 1
  end

  def header(node)
    block do
      out("<h", node.header_level, "id=\"header-#{@header_id}\">",
          :children, "</h", node.header_level, ">")

      TocList.append(level: node.header_level, id: "header-#{@header_id}")
      @header_id += 1
    end
  end
end

# todo
class TocList
  class << self
    def toc
      @toc ||= []
    end

    def append(level:, id:)
      toc << { level: level, id: id }
    end

    def each(&block)
      toc.each(&block)
    end
  end
end

# テスト用のマークダウンテキスト
Benchmark.bmbm do |x|
  x.report("markly:") do
    100.times do
      document = Markly.parse(markdown_text, extensions: %i[table strikethrough])
      output = []
      MyHtmlRenderer.new.render(document)
      TocList.each do |item|
        output << "<a class=\"heading-level-#{item[:level]}\" href=\"#header-#{item[:id]}\""
      end
      output.join("\n")
    end
  end

  x.report("qiita-markdown:") do
    100.times do
      processor = Qiita::Markdown::Processor.new(hostname: "example.com")
      processor.call(markdown_text)[:output].to_s
    end
  end

  x.report("markdown-it-rust:") do
    100.times do
      MarkdownRustified.convert_all(markdown_text)
    end
  end
end
