defmodule PhoenixQcExample.Generators do
  import Pollution.{VG}

  def gen_commands(names) do
    list(of: choose(from: [gen_vote(names)]), max: 20)
  end

  def gen_vote(names) do
    tuple(like: {
      value(:vote),
      choose(from: names),
      choose(from: [value(1), value(2), value(3)])} )
  end
end
