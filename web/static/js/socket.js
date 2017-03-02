import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})

socket.connect()

let channel = socket.channel("room:voting", {})
let voteButtons = document.querySelectorAll('.vote-button')
let resetButton = document.querySelector('.reset-button')
const userName = () => document.querySelector('.user-name').value

// resetButton.addEventListener('click', e => {
//   reset()
// })

for (var i = 0; i < voteButtons.length; i++) {
  var button = voteButtons[i]
  button.addEventListener("click", e => {
    let id = e.target.dataset.id
    sendPost(id)
  })
}

function reset() {
  var request = new XMLHttpRequest();
  request.open('POST', `/api/reset`, true);
  request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=UTF-8');
  request.send(null);
}

function sendPost(id) {
  var request = new XMLHttpRequest();
  request.open('POST', `/api/restaurants/${id}/votes`, true);
  request.setRequestHeader('Content-Type', 'application/json; charset=UTF-8');
  request.send(JSON.stringify({name: userName()}));
}

function initializeCounts({votes: votes}) {
  updateCount("1", votes["1"])
  updateCount("2", votes["2"])
  updateCount("3", votes["3"])
}

function updateCount(id, votes) {
  let voteCount = document.querySelector(`[data-voter-id="${id}"]`)
  let voteList = document.querySelector(`[data-vote-list-id="${id}"]`)

  voteCount.innerText = votes.length
  voteList.innerHTML = voteListHtml( votes.map(vote => voteListItem(vote)) )
}

const voteListItem = (vote) => {
  return `
    <li class="vote">
      ${vote}
    </li>
  `
}

const voteListHtml = (listItems) => (
  listItems.reduce( (string, item) => string + item, "" )
)

channel.join()
  .receive("ok", resp => { initializeCounts(resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

channel.on("new:vote", payload => { updateCount(payload.id, payload.votes) })
channel.on("reset", payload => { initializeCounts(payload) })

export default socket
