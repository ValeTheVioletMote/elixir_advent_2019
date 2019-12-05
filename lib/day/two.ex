defmodule Advent.Day.Two do

 @doc """
 Takes a program as a list of integer opcodes and values.

 1 is an instruction to add together the values pointed by the next two instructions and override this sum at the position given by the third instruction.

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

end
