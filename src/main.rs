use std::fmt;

use rand::Rng;
use serde::Deserialize;
use structopt::StructOpt;

#[derive(Debug, Deserialize)]
pub struct Fortune {
    pt: String,
}

impl fmt::Display for Fortune {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "{}", self.pt)
    }
}

fn main() {
    let opt = Opt::from_args();
    if opt.ascii {
        let ascii_puppy = include_str!("../data/puppy.ascii");
        println!("{}", ascii_puppy);
        return ();
    }
    let puppy_tweets: Vec<Fortune> =
        serde_json::from_str(include_str!("../data/puppy.json")).unwrap();
    println!(
        "{}",
        puppy_tweets[rand::thread_rng().gen_range(0, puppy_tweets.len())]
    );
}

/// what if fortune but with puppy tweets
#[derive(StructOpt, Debug)]
struct Opt {
    /// Prints ascii puppy
    #[structopt(short, long)]
    ascii: bool,
}
