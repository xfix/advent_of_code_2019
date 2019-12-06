defmodule AdventOfCode2019.Day6 do
  @moduledoc """
  Day 6 solutions
  """

  @doc ~S"""
  Solves the first riddle of day 6.

  ## Examples

      iex> AdventOfCode2019.Day6.part1("COM)B\nB)C\nC)D\nD)E\nE)F\nB)G\nG)H\nD)I\nE)J\nJ)K\nK)L")
      42
      iex> File.read!("inputs/day6.txt") |> AdventOfCode2019.Day6.part1
      241064

  """
  def part1(input) do
    parse_map(input) |> Enum.reduce(%{}, &add_key/2) |> compute_checksum("COM", 0)
  end

  @doc ~S"""
  Solves the second riddle of day 6.

  ## Examples


      iex> AdventOfCode2019.Day6.part2("COM)B\nB)C\nC)D\nD)E\nE)F\nB)G\nG)H\nD)I\nE)J\nJ)K\nK)L\nK)YOU\nI)SAN")
      4
      iex> File.read!("inputs/day6.txt") |> AdventOfCode2019.Day6.part2
      418

  """
  def part2(input) do
    [depth] =
      parse_map(input)
      |> Enum.reduce(%{}, &add_graph_key/2)
      |> graph_search(-1, MapSet.new(), "YOU")
      |> Enum.take(1)

    depth
  end

  defp parse_map(input) do
    String.trim(input) |> String.split("\n") |> Enum.map(&String.split(&1, ")"))
  end

  defp add_key([a, b], map) do
    Map.update(map, a, [b], &[b | &1])
  end

  defp add_graph_key([a, b], map) do
    map = Map.update(map, a, [b], &[b | &1])
    Map.update(map, b, [a], &[a | &1])
  end

  defp compute_checksum(map, key, res) do
    Map.get(map, key, [])
    |> Enum.map(&compute_checksum(map, &1, res + 1))
    |> Enum.sum()
    |> Kernel.+(res)
  end

  defp graph_search(map, depth, visited, current_point) do
    visited = MapSet.put(visited, current_point)
    candidates = Map.get(map, current_point, []) |> Enum.filter(&(!MapSet.member?(visited, &1)))

    if Enum.any?(candidates, &(&1 == "SAN")) do
      [depth]
    else
      Stream.flat_map(candidates, &graph_search(map, depth + 1, visited, &1))
    end
  end
end