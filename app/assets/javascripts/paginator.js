document.addEventListener("DOMContentLoaded", () => {
    const hellip = document.querySelector("[data-go-to-page='true']");
    hellip.addEventListener("click", function () {
        if(hellip.firstElementChild.innerHTML === "…♥") {
            const span = hellip.querySelector('span');
            span.innerHTML = '<input type="text" name="go_to_page" class="custom-input" size="4">';
            document.querySelector("[name='go_to_page']").focus();
        }
    });
    hellip.addEventListener("keypress", function (e) {
        const new_page = hellip.firstElementChild.firstElementChild.value;
        const charCode = (e.which) ? e.which : e.keyCode;
        const max_page = hellip.parentElement.children[hellip.parentElement.childElementCount - 2].firstElementChild.innerHTML
        if (charCode === 13 && new_page > 0) {
            if(new_page > Number(max_page)){
                window.location.href = window.location.origin + window.location.pathname + "?page=" + Number(max_page)
            }else{
                window.location.href = window.location.origin + window.location.pathname + "?page=" + Number(new_page)
            }
        }
    });
});