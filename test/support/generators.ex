defmodule PhoenixQcExample.Generators do
  import Pollution.VG

  def gen_commands() do
    list(of: choose(from: [gen_reset(), gen_vote()]), max: 10)
  end

  def gen_reset() do
    tuple(like: {value(:reset), value([])})
  end

  def gen_vote do
    tuple(like: {value(:vote), choose(from: [value(1), value(2), value(3)])} )
  end
end
