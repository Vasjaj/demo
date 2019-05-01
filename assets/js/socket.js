import {Socket} from "phoenix";

let socket = new Socket("/socket", {params: {token: window.userToken}});

socket.connect();

const createSocket = (postId) => {
  let channel = socket.channel(`comments:${postId}`, {})
  
  channel.join()
    .receive("ok", resp => {
      renderComments(resp.comments);
      console.log(resp)
    })
    .receive("error", resp => { console.log("Unable to join", resp) })

  document.querySelector("button").addEventListener("click", () => {
    const content = document.querySelector("textarea").value;

    channel.push("comment:add", {content: content});
  })

  channel.on(`comments:${postId}:new`, renderComment);
}

function renderComments(comments) {
  comments.map(comment => {
    document.querySelector(".collection").append(commentTemplate(comment));
  })

}

function renderComment(event) {
  document.querySelector(".collection").append(commentTemplate(event.comment));
}

function commentTemplate(comment) {
  let li = document.createElement("li");
  li.innerHTML = (comment.user) ? comment.user.email : "Anonymous";

  let div = document.createElement("div");
  div.innerHTML = comment.content;

  li.append(div)
  
  return li;
}

window.createSocket = createSocket