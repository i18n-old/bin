use aok::{Result, OK};
use clap::{arg, Command};

fn main() -> Result<()> {
  let m = Command::new("")
    .disable_version_flag(true)
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
    // .subcommand(
    //   Command::new("test")
    //     .about("does testing things")
    //     .arg(arg!(-l --list "lists test values").action(ArgAction::SetTrue)),
    // )
    .get_matches();
  if m.get_one::<bool>("version") == Some(&true) {
    println!("version");
  }

  OK
}
