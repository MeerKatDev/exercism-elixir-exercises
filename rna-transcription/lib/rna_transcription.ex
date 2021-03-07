defmodule RnaTranscription do
  @doc """
  Transcribes a character list representing DNA nucleotides to RNA

  ## Examples

  iex> RnaTranscription.to_rna('ACTG')
  'UGAC'
  """
  @spec to_rna([char]) :: [char]
  def to_rna(dna) do
    Enum.map(dna, fn x ->
      case x do
	?A -> ?U
	?C -> ?G
	?T -> ?A
	?G -> ?C
      end
    end)
  end
end
