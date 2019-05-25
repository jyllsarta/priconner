function onItemClicked(domObject){
    selectItem(domObject);
    updateItemIds();
}

function selectItem(domObject){
    $(domObject.currentTarget).toggleClass("selected");
}

// hidden_fieldに仕込んだitem_idの配列を更新する
function updateItemIds(){
    $("#item_ids").attr("value",selectedItemIds());
}

function selectedItemIds(){
    return $(".selected .id").map(function(_, elem){ return parseInt(elem.innerText) }).toArray();
}

$(function() {
    $(".clickable_item").click(onItemClicked);
});