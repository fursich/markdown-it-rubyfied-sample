mod driver;
mod extensions;
use magnus::{define_module, function, prelude::*, Error};

use driver::MarkdownDriver;

fn convert(contents: String) -> String {
    let handler = MarkdownDriver::new();
    handler.parse(contents);
    handler.render()
}

fn convert_with_toc(contents: String) -> (String, String) {
    let handler = MarkdownDriver::new();
    handler.parse(contents);
    (handler.render(), handler.render_toc())
}

#[magnus::init]
fn init() -> Result<(), Error> {
    let module = define_module("MarkdownIt")?;
    module.define_singleton_method("convert", function!(convert, 1))?;
    module.define_singleton_method("convert_with_toc", function!(convert_with_toc, 1))?;

    Ok(())
}
