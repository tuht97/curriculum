defmodule FileSearch do
  @moduledoc """
  Documentation for FileSearch
  """

  @doc """
  Find all nested files.

  For example, given the following folder structure
  /main
    /sub1
      file1.txt
    /sub2
      file2.txt
    /sub3
      file3.txt
    file4.txt

  It would return:

  ["file1.txt", "file2.txt", "file3.txt", "file4.txt"]
  """
  def all(folder) do
    File.ls!(folder)
    |> Enum.flat_map(fn
      file ->
        path = Path.join(folder, file)
        if File.dir?(path), do: all(path), else: [path]
    end)
  end

  @doc """
  Find all nested files and categorize them by their extension.

  For example, given the following folder structure
  /main
    /sub1
      file1.txt
      file1.png
    /sub2
      file2.txt
      file2.png
    /sub3
      file3.txt
      file3.jpg
    file4.txt

  The exact order and return value are up to you as long as it finds all files
  and categorizes them by file extension.

  For example, it might return the following:

  %{
    ".txt" => ["file1.txt", "file2.txt", "file3.txt", "file4.txt"],
    ".png" => ["file1.png", "file2.png"],
    ".jpg" => ["file3.jpg"]
  }
  """
  def by_extension(folder) do
    all(folder)
    |> Enum.group_by(&Path.extname/1, &Path.basename/1)
  end

  def main(args) do
    {opts, _word, _errors} = OptionParser.parse(args, switches: [by_type: :boolean])
    by_type = opts[:by_type] || false

    if by_type,
      do: FileSearch.by_extension("./main"),
      else: FileSearch.all("./main")
  end
end
