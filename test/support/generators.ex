defmodule PhoenixQcExample.Generators do
  import Pollution.{VG}

  def gen_commands() do
    list(of: choose(from: [gen_vote()]), max: 20)
  end

  def gen_commands(name) do
    list(of: choose(from: [gen_vote(name)]), max: 20)
  end

  def gen_vote() do
    tuple(like: {
      value(:vote),
      choose(from: [value("chris"), value("jane")]),
      choose(from: [value(1), value(2), value(3)])} )
  end

  def gen_vote(name) do
    tuple(like: {
      value(:vote),
      choose(from: [value(name)]),
      choose(from: [value(1), value(2), value(3)])} )
  end
end
