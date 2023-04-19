# Ok and Error Result Containers

## Setup

If you are using asdf, run `make asdf-setup`.

If not, please review and meet the Ruby version in .tool-versions.

## Run

Run `make run`.

## About

This is a simple sample application to explain the pattern matching portion of Rustish Result.

The main purpose is to expand upon using Ruby pattern matching for error handling, as well as give a vision for what a gateway is.

It is, in reality, an Action variant called a GatewayAction. Gateways extend GatewayAction, and their public interfaces return Rustish::Result, either Ok or Err.

Unlike the current Tr::Result, which encapsulates a Result object that enforces it can only be Ok or Err, this makes no assumption of the Result object as anything more than a wrapper for constructing the scope of Ok and Err.

Since all public methods will return either an Ok or an Err container, we can use this result container to handle errors in these Actions. We can either use literate style with auto-handling like #unwrap_or, or we can match the result class and always exhaustively check both Ok and Err conditions.

Please see `main.rb` for an example.
