window.onload = function() {
  document.getElementById("bank").onclick = bank;

  function bank(){
    document.getElementById("bank_checkbox").checked = true;
    document.getElementById("dice_form").submit();
  }
  
}