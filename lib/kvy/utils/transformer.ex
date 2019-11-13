defmodule Kvy.Utils.Transformer do
  def map_keys_to_atom(map) when is_map(map) do
    Map.new(map, fn {k, v} -> {String.to_atom(k), v} end)
  end

  def map_keys_to_string(map) when is_map(map) do
    Map.new(map, fn {k, v} -> {Atom.to_string(k), v} end)
  end
end
