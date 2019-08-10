$(document).ready(function () {
    $("#daily_invoice_form").validate();
    $('.selectpicker').selectpicker();

    $('#calendar1').click(function(){
        $(".bill_date").datepicker({dateFormat: "yy-mm-dd"}).focus();
    });
    $('#calendar2').click(function(){
        $(".date").multiDatesPicker({dateFormat: "yy-mm-dd"}).focus();
    });

    $('#daily_invoice_is_prepaid').click(function(){
        $("#bill_id").addClass("required");
    });

    $('#daily_invoice_expense_type').on('change', function () {

        if($("#daily_invoice_expense_type").val() == "CustomExpense")
        {
            $("#custom_expense_modal_id").modal('show');
        }

    });

});