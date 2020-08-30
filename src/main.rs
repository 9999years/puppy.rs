use rand::Rng;
use serde::Deserialize;
use std::fmt;

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
    let puppy_tweets: Vec<Fortune> = serde_json::from_str(include_str!("puppy.json")).unwrap();
    println!(
        "{}",
        puppy_tweets[rand::thread_rng().gen_range(0, puppy_tweets.len())]
    );
}
