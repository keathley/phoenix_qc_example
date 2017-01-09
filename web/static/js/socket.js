import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})

socket.connect()

let channel = socket.channel("room:voting", {})
let voteButtons = document.querySelectorAll('.vote-button')
let resetButton = document.querySelector('.reset-button')

resetButton.addEventListener('click', e => {
  reset()
})

voteButtons.forEach(button => {
  button.addEventListener("click", e => {
    let id = e.target.dataset.id
    sendPost(id)
  })
})

function reset() {
  var request = new XMLHttpRequest();
  request.open('POST', `/api/reset`, true);
  request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=UTF-8');
  request.send(null);
}

function sendPost(id) {
  var request = new XMLHttpRequest();
  request.open('POST', `/api/restaurants/${id}/votes`, true);
  request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=UTF-8');
  request.send(null);
}

function initializeCounts({counts: counts}) {
  updateCount("1", counts["1"])
  updateCount("2", counts["2"])
  updateCount("3", counts["3"])
}

function updateCount(id, count) {
  let voteCount = document.querySelector(`[data-voter-id="${id}"]`)
  voteCount.innerText = count
}

channel.join()
  .receive("ok", resp => { initializeCounts(resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

channel.on("new:vote", payload => { updateCount(payload.id, payload.count) })
channel.on("reset", payload => { initializeCounts(payload) })

export default socket
