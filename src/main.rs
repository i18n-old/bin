#![feature(async_closure)]
use std::process::exit;
mod mirror;
use aok::{Result, OK};
use clap::{arg, crate_version, Command};
use current_platform::CURRENT_PLATFORM;
pub use mirror::MIRROR;

fn main() -> Result<()> {
  dbg!(MIRROR);
  // dbg!(bgu::ver!());

  let arg_len = std::env::args().count();
  if arg_len == 1 {
    println!("{}", CURRENT_PLATFORM);
    exit(0);
  }

  let m = Command::new("i18n.site").disable_version_flag(true)
    // .arg(arg!([name] "Optional name to operate on"))
    // .arg(
    //   arg!(
    //             -c --config <FILE> "Sets a custom config file"
    //         )
    //         // We don't have syntax yet for optional options, so manually calling `required`
    //         .required(false)
    //         .value_parser(value_parser!(PathBuf)),
    // )
    .arg(arg!(
        -v --version
    ))
    .arg(arg!(
        - -vv "more version info"
    ))
    // .subcommand(
    //   Command::new("test")
    //     .about("does testing things")
    //     .arg(arg!(-l --list "lists test values").action(ArgAction::SetTrue)),
    // )
    .get_matches();
  if m.get_one("version") == Some(&true) {
    println!(crate_version!());
    exit(0);
  }
  if m.get_one("vv") == Some(&true) {
    println!(
      r#"ver:{}
build_target:{}"#,
      crate_version!(),
      CURRENT_PLATFORM
    );
    exit(0);
  }

  OK
}
