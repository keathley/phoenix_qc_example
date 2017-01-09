module Allocation exposing (..)

import Http
import Json.Decode as Json
import Html exposing (Html, h1, div, p, text, button)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Phoenix.Socket
import Phoenix.Channel
import Phoenix.Push

type alias Model =
  {
    voted : Bool
  , restaurants : List Restaurant
  , phxSocket : Phoenix.Socket.Socket Msg
  }

type alias Restaurant =
  {
    id : Int
  , name : String
  , votes : Int
  }

type alias User =
  {
    name : String
  }

type Msg
  = Vote Restaurant
  | NewVote (Result Http.Error String)
  | PhoenixMsg (Phoenix.Socket.Msg Msg)

model =
  {
    voted=False
  , restaurants=[
      { id=1, name="Thai", votes=0 }
    , { id=2, name="Sushi", votes=0 }
    , { id=3, name="Burritos", votes=0 }
    ]
  , phxSocket = initPhxSocket
  }

initPhxSocket =
  Phoenix.Socket.init "ws://localhost:4000/socket/websocket"
  |> Phoenix.Socket.withDebug
  |> Phoenix.Socket.on "new:vote" "rooms:votes" ReceiveNewVote

decodeResponse =
  Json.at ["data", "image_url"] Json.string

voteForRestaurant : Int -> Cmd Msg
voteForRestaurant rId =
  let
    url =
      "/api/restaurants/"++toString rId++"/votes"

    request =
      Http.post url Http.emptyBody decodeResponse
  in
    Http.send NewVote request

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Vote restaurant ->
      (model, voteForRestaurant restaurant.id)

    NewVote (Ok _) ->
      (model, Cmd.none)

    NewVote (Err _) ->
      (model, Cmd.none)

    PhoenixMsg msg ->
      let
        ( phxSocket, phxCmd ) = Phoenix.Socket.update msg model.phxSocket
      in
        ( { model | phxSocket = phxSocket }
        , Cmd.map PhoenixMsg phxCmd
        )

subscriptions : Model -> Sub Msg
subscriptions model =
  Phoenix.Socket.listen model.phxSocket PhoenixMsg

view model =
  div
    [ class "row" ]
    (List.map restaurantChoice model.restaurants)

restaurantChoice restaurant =
  div
    [ class "col-md-4" ]
    [
      h1 [ class "text-center" ] [
        text (restaurant.name)
      ]
    , voteButton restaurant
    ]

voteButton restaurant =
  div
    [ class "restaurant-actions" ]
    [
      button
        [
          class "vote-button btn btn-primary",
          onClick (Vote restaurant)
        ]
        [ text "vote" ]
    ]

main =
  Html.program
    {
      init=(model, Cmd.none)
    , view=view
    , update=update
    , subscriptions=subscriptions
    }
