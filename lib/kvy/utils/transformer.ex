defmodule Kvy.Utils.Transformer do
  def map_keys_to_atom(map) when is_map(map) do
    Map.new(map, fn {k, v} -> {String.to_atom(k), v} end)
  end
end
