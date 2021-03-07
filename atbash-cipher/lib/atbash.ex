defmodule Atbash do

  @doc """
  Encode a given plaintext to the corresponding ciphertext

  ## Examples

  iex> Atbash.encode("completely insecure")
  "xlnko vgvob rmhvx fiv"
  """
  @spec encode(String.t()) :: String.t()
  def encode(plaintext) do
    plaintext
    |> String.replace(~r/[^A-Za-z0-9]/, "")
    |> String.replace(~r/.{5}/, "\\0 ")
    |> String.trim
    |> to_charlist
    |> Enum.map_join(fn
      x when x in ?A..?Z ->
        <<(?a + rem(?z - (x+32), 26))::utf8>>
      x when x in ?a..?z ->
        <<(?a + rem(?z - x, 26))::utf8>>
      x ->
        <<x::utf8>>
    end)

  end

  @spec decode(String.t()) :: String.t()
  def decode(cipher) do
    cipher
    |> to_charlist
    |> Enum.map_join(fn
      ?\s ->
        ''
      x when x in ?a..?z ->
        <<(?a + rem(?z - x, 26))::utf8>>
      x ->
        <<x::utf8>>
    end)
  end
end
