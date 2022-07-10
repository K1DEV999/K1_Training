var posturl = "https://K1_Training/";
Config.closeKeys = [27, 77, 113, 112];

$(document).ready(function () {
    $("#wrapper").hide();
    $("#press").hide();
    $("#revivewait").hide();
    $("body").on("keyup", function (key) {
        if (Config.closeKeys.includes(key.which)) {
            closeNUI();
        }
    });
    const scrollContainer = document.querySelector(".content");

    scrollContainer.addEventListener("wheel", (evt) => {
        evt.preventDefault();
        scrollContainer.scrollLeft += evt.deltaY;
    });
    $('body').on('click','[data-button]', function(){
        var item = $(this).attr('data-button');
        var itemdata = $('#item-' + item).data("item");

        var obj = JSON.stringify(itemdata.Type);

        let result = obj.substr(1, 4);
        if (result === "item") {
            Swal.fire({
                title: "ซื้อสินค้า",
                text: "กรุณากรอกจำนวน",
                input: 'number',
                showCancelButton: true ,
                confirmButtonColor: 'green'
                }).then((result) => {
                if (result.value) {
                    var data = [];
                    let text = {
                        "countitemsel" : result.value
                    }
                    data.push(itemdata, text);
                    sen(data);
                } else if (result.value === "") {
                    Swal.fire(
                        'Zone Esport',
                        'กรุณากรอกจำนวนที่ต้องการจะซื้อ',
                        'info'
                    );
                }
            });
        } else {
            sen(itemdata);
        }
    });   
});

window.addEventListener("message", function (e) {
    var event = e.data;
    var action = e.data.action;
    var display = e.data.display;

    if (display == "open") {
        $("#wrapper").fadeIn(300);
    } else if (display == "openinzone") {
        $("#box-text-wel").fadeIn(300);
    } else if (display == "closeinzone") {
        $("#wrapper").hide();
        $("#box-text-wel").fadeOut(300);
    } else if (action == "revivewait") {
        $("#revivewait").fadeIn(300);
        revivewaitfunc(e.data.text);
    } else if (action == "pressKey") {
        pressKey(e.data.text, e.data.bool);
    }
    if (e.data.action == "itemsent") {
        loaditem(e.data.itemall);
    }
});

revivewaitfunc = (t) => {
    $("#text-revive").html(t);
}

pressKey = (t, b) => {
    if (b == true) {
        $("#revivewait").hide();
        $("#press").fadeIn(300);
        $("#press").html(`<div class="notify-text">${t}</div>`);
    } else if (b == false) {
        $("#press").hide();
    }
}
sen = (itemdata) => {
    $.post(posturl + "callbackbuy", JSON.stringify({
        itemcall : itemdata
    }));
}

loaditem = (data) => {
    $(".content").html("");

    for (const [index, item] of Object.entries(data)) {
        // console.log(JSON.stringify(item));
        var IPS = `
        <div class="slot" id="item-${index}">
            <div class="item">
                <img src="${Config.inventoryURL}${item.itemList}.png" class="img-weapon" alt="">
                <span id="name-tag">${item.name}</span>
                <span id="price-tag">${item.Price} $</span>
               <div class="button-submit" data-button="${index}">ซื้อ</div>
            </div>
        </div>
        `
        $(".content").append(IPS);
        $('#item-' + index).data('item', item);

    }
}

closeNUI = () => {
    $("#wrapper").hide();
    $.post(posturl + "closeNUI", JSON.stringify({}));
}