defmodule ScrollerWeb.ClientLiveTest do
  use ScrollerWeb.ConnCase

  import Phoenix.LiveViewTest
  import Scroller.ScrollersFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_client(_) do
    client = client_fixture()
    %{client: client}
  end

  describe "Index" do
    setup [:create_client]

    test "lists all scrollers", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/scrollers")

      assert html =~ "Listing Scrollers"
    end

    test "saves new client", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/scrollers")

      assert index_live |> element("a", "New Client") |> render_click() =~
               "New Client"

      assert_patch(index_live, ~p"/scrollers/new")

      assert index_live
             |> form("#client-form", client: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#client-form", client: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/scrollers")

      assert html =~ "Client created successfully"
    end

    test "updates client in listing", %{conn: conn, client: client} do
      {:ok, index_live, _html} = live(conn, ~p"/scrollers")

      assert index_live |> element("#scrollers-#{client.id} a", "Edit") |> render_click() =~
               "Edit Client"

      assert_patch(index_live, ~p"/scrollers/#{client}/edit")

      assert index_live
             |> form("#client-form", client: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#client-form", client: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/scrollers")

      assert html =~ "Client updated successfully"
    end

    test "deletes client in listing", %{conn: conn, client: client} do
      {:ok, index_live, _html} = live(conn, ~p"/scrollers")

      assert index_live |> element("#scrollers-#{client.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#client-#{client.id}")
    end
  end

  describe "Show" do
    setup [:create_client]

    test "displays client", %{conn: conn, client: client} do
      {:ok, _show_live, html} = live(conn, ~p"/scrollers/#{client}")

      assert html =~ "Show Client"
    end

    test "updates client within modal", %{conn: conn, client: client} do
      {:ok, show_live, _html} = live(conn, ~p"/scrollers/#{client}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Client"

      assert_patch(show_live, ~p"/scrollers/#{client}/show/edit")

      assert show_live
             |> form("#client-form", client: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#client-form", client: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/scrollers/#{client}")

      assert html =~ "Client updated successfully"
    end
  end
end
