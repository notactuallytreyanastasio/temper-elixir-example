defmodule DraftWeb.DraftLiveTest do
  use DraftWeb.ConnCase
  import Phoenix.LiveViewTest

  test "the diff of the two drafts comes from the Temper library", %{conn: conn} do
    {:ok, view, html} = live(conn, "/")
    assert html =~ ~r{<span class="bg-red-200[^"]*">brown</span>}
    assert html =~ ~r{<span class="bg-green-200[^"]*">red</span>}

    html = view |> element("#texts") |> render_change(%{"before" => "one two", "after" => "one three"})
    assert html =~ ~r{<span class="bg-red-200[^"]*">two</span>}
    assert html =~ ~r{<span class="bg-green-200[^"]*">three</span>}
    assert html =~ "2 words · 0 sentences"
  end
end
