window.onload = function() {
  document.getElementById("bank").onclick = bank;

  function bank(){
    document.getElementById("bank_checkbox").checked = true;
    document.getElementById("dice_form").submit();
  }

  document.getElementById("potential_button").onclick = potential;


  // $("#dice_form").ajaxForm({url: '/potential_score', type: 'post'})

  function potential() {
    // var url = "/potential_score"

    // $.ajax({
    //   type: "POST",
    //   url: url,
    //   data: data,
    //   success: $("#potential_score")[0].innerText = this.response,
    //   dataType: "json"
    // });

    var request = new XMLHttpRequest();
    var formElement = document.getElementById("dice_form");
    request.open("get", "/potential_score");
    request.responseType = "json"
    request.send(new FormData(formElement));
//
    request.addEventListener("load", function() {
      alert("poop")
      // var score = this.response;
      // $("#potential_score")[0].innerText = score;
    });
  }
}