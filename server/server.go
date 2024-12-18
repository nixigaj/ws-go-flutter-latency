package main

import (
	"fmt"
	"log"
	"net/http"

	"github.com/gorilla/websocket"
)

var upgrader = websocket.Upgrader{
	CheckOrigin: func(r *http.Request) bool {
		return true
	},
}

func echo(w http.ResponseWriter, r *http.Request) {
	conn, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		log.Println("Upgrade:", err)
		return
	}
	defer conn.Close()

	for {
		_, message, err := conn.ReadMessage()
		if err != nil {
			log.Println("ReadMessage:", err)
			break
		}

		// Echo the message back
		err = conn.WriteMessage(websocket.TextMessage, message)
		if err != nil {
			log.Println("WriteMessage:", err)
			break
		}
	}
}

func main() {
	http.HandleFunc("/ws", echo)
	fmt.Println("WebSocket server started at :13123")
	log.Fatal(http.ListenAndServe(":13123", nil))
}
