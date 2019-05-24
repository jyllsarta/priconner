function selectItem(domObject){
    $(domObject.currentTarget).toggleClass("selected");
}

function selectedItemIds(){
    return $(".selected .id").map(function(_, elem){ return parseInt(elem.innerText) }).toArray();
}

$(function() {
    $(".clickable_item").click(selectItem);
});