defmodule Exp.Format.FileOutput do
    @moduledoc """
        Formatting the export of entry tables to output files.
    """


    def format_content(content_array, format, agg \\ "")

    def format_content([], :csv, agg), do: agg
    def format_content([h| []], :csv, agg), do: agg <> h
    def format_content([h| t], :csv, agg) do
        tmp_result = agg <> h <> ","
        format_content(t, :csv, tmp_result)
    end


end