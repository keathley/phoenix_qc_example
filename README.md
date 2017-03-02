# PhoenixQcExample

## What is this?

This is an example application that demonstrates a way to run property tests against a web application. It uses concurrent tests to (hopefully) find race conditions. The algorithm for the concurrent testing is based on [Finding Race Conditions in Erlang with QuickCheck and Pulse](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.724.3518&rep=rep1&type=pdf).

## Starting the phoenix app

To start your Phoenix app:

  * Install dependencies with `mix deps.get`
  * Install Node.js dependencies with `npm install`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
