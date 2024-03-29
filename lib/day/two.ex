defmodule Advent.Day.Two do

 @doc """
 Takes a program as a list of integer opcodes and values.

 1 is an instruction to add together the values pointed by the next two instructions and override this sum at the address given by the third instruction.

 2 is as 1, but with multiplication.

 99 indicates the end of the program.

  iex> Advent.Day.Two.process_program [1,9,10,3,2,3,11,0,99,30,40,50]
  [3500, 9, 10, 70, 2, 3, 11, 0, 99, 30, 40, 50]

  iex> Advent.Day.Two.process_program [1,0,0,0,99]
  [2, 0, 0, 0, 99]

  iex> Advent.Day.Two.process_program [2,3,0,3,99]
  [2, 3, 0, 6, 99]

  iex> Advent.Day.Two.process_program [2,4,4,5,99,0]
  [2,4,4,5,99,9801]

  iex> Advent.Day.Two.process_program [1,1,1,4,99,5,6,0,99]
  [30,1,1,4,2,5,6,0,99]

 """
 @spec process_program([integer], integer) :: [integer]
 def process_program(program, pointer \\ 0) do
  case {Enum.at(program, pointer), Enum.slice(program, pointer+1..pointer+3)} do
    {1, instructions} -> program |> process_instructions(instructions, &Kernel.+/2) |> process_program(pointer+4)
    {2, instructions} -> program |> process_instructions(instructions, &Kernel.*/2) |> process_program(pointer+4)
    {99,_} -> program
    _-> raise "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA!"
  end
 end

 defp process_instructions(program, [arg1_loc, arg2_loc, output_loc]=_instructions, func) when is_list(program) and is_function(func) do
  List.replace_at(program, output_loc,
  func.(
    Enum.at(program, arg1_loc),
    Enum.at(program, arg2_loc)
    ))
 end

 @d2data File.read!("data/daytwo")
        |> String.split(",")
        |> Enum.map(fn str -> with {n, _} <- Integer.parse(str), do: n end)

 @doc """
 Determines the answers to the Advent Parts.
  iex> Advent.Day.Two.get_answer(1)
  3895705
  iex> Advent.Day.Two.get_answer(2)
  6417
 """
 @spec get_answer(part :: number) :: String.t
 def get_answer(part \\ 1)
 def get_answer(1), do: @d2data |> run_gravity_assist(12, 2)
 def get_answer(2) do
  with {:ok, {noun, verb}} <- get_partitioned_guess_stream()
  |> Task.async_stream(&scour_for_answer/1, max_concurrency: System.schedulers_online()*2)
  |> Enum.find(fn {:ok, v} -> match? {_noun, _verb}, v end),
  do: 100*noun+verb
 end

 defp scour_for_answer(stream) do
  Enum.find(stream, fn {noun, verb} -> run_gravity_assist(@d2data, noun, verb) == 19690720 end)
 end

 defp get_partitioned_guess_stream do
  0..99
  |> Enum.map(fn n -> Stream.unfold(0,
    fn
      v when v > 99 -> nil
      v -> {{n,v}, v+1}
    end
  ) end)
 end

 defp run_gravity_assist(data, noun, verb) do
  data
  |> List.replace_at(1, noun)
  |> List.replace_at(2, verb)
  |> process_program
  |> Enum.at(0)
 end
end
