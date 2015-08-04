window.onload = function() {
  document.getElementById("bank").onclick = bank;

  function bank(){
    document.getElementById("bank_checkbox").checked = true;
    document.getElementById("dice_form").submit();
  }

  var checkboxes = $(".cube_checkbox");
  for(var x = 0; x < checkboxes.length; x++){
    checkboxes[x].onclick = potential;
  }
  document.getElementById("potential_button").onclick = potential;
  
  function potential() {
    var request = new XMLHttpRequest();
    var formElement = document.getElementById("rolled_dice");
    request.open("POST", "/potential_score");
  
    // sends info from form (via FormData) to previously opened POST route
    // request.responseType = "json";
    var lll = new FormData(formElement);
    request.send(new FormData(formElement));
  
    request.addEventListener("load", function() {
      document.getElementById("potential_score").innerText = this.response
    });
  
  };
}

  // $("#dice_form").ajaxForm({url: '/potential_score', type: 'post'})

  // function potential() {
    // var url = "/potential_score"

    // $.ajax({
    //   type: "POST",
    //   url: url,
    //   data: data,
    //   success: $("#potential_score")[0].innerText = this.response,
    //   dataType: "json"
    // });

    // var request = new XMLHttpRequest();
    // var formElement = document.getElementById("rolled_dice");
    // request.open("get", "potential_score");
    // request.responseType = "json"
    // request.send(new FormData(formElement));
//
    // request.addEventListener("load", function() {
      // alert("poop")
      // var score = this.response;
      // $("#potential_score")[0].innerText = score;
    // });
  // }