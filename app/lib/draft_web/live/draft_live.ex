defmodule DraftWeb.DraftLive do
  @moduledoc """
  Two versions of a draft, and what changed between them.

  The diff and the counts come from textkit, a Temper library generated into
  Elixir: `Temper.Textkit.diff/2` returns a list of
  `%Temper.Textkit.Piece{kind, text}` structs, and `Temper.Textkit.stats/1` a
  `%Temper.Textkit.Stats{}`. Edit `temper/textkit/src/words.temper.md`, and
  this page reloads with the new code.
  """
  use DraftWeb, :live_view

  @before_text "The quick brown fox jumps over the lazy dog. It was not amused."
  @after_text "The quick red fox leaps over the lazy dog. It was amused!"

  @impl true
  def mount(_params, _session, socket), do: {:ok, assign_texts(socket, @before_text, @after_text)}

  @impl true
  def handle_event("change", %{"before" => before, "after" => later}, socket),
    do: {:noreply, assign_texts(socket, before, later)}

  defp assign_texts(socket, before, later) do
    assign(socket,
      before: before,
      later: later,
      # a Temper List is Enumerable
      pieces: Enum.to_list(Temper.Textkit.diff(before, later)),
      before_stats: Temper.Textkit.stats(before),
      later_stats: Temper.Textkit.stats(later)
    )
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <h1 class="text-2xl font-semibold">Draft diff</h1>
      <p class="mt-1 text-sm opacity-70">
        Computed by <code>textkit</code>, written in Temper and generated into Elixir.
        Edit <code>temper/textkit/src/words.temper.md</code> and this page updates.
      </p>
      <form id="texts" phx-change="change" class="mt-4 grid grid-cols-2 gap-4">
        <textarea name="before" rows="5" class="textarea w-full">{@before}</textarea>
        <textarea name="after" rows="5" class="textarea w-full">{@later}</textarea>
      </form>
      <div class="mt-1 grid grid-cols-2 gap-4 text-sm opacity-70">
        <.counts stats={@before_stats} />
        <.counts stats={@later_stats} />
      </div>
      <p id="diff" class="mt-6 text-lg leading-relaxed whitespace-pre-wrap"><span
          :for={piece <- @pieces}
          class={piece_class(piece.kind)}
        >{piece.text}</span></p>
    </Layouts.app>
    """
  end

  attr :stats, :any, required: true

  defp counts(assigns) do
    ~H"""
    <p>
      {@stats.words} words · {@stats.sentences} sentences ·
      {@stats.characters} characters · {@stats.readingSeconds} s to read
    </p>
    """
  end

  defp piece_class("added"), do: "bg-green-200 text-green-900"
  defp piece_class("removed"), do: "bg-red-200 text-red-900 line-through"
  defp piece_class(_same), do: nil
end
