{let can_apply=false()}
<form name="orderlist" method="post" action={concat( '/owshop/orderlist', $view_parameters.offset|gt(0)|choose( '', concat( '/(offset)/', $view_parameters.offset ) ) )|ezurl}>

<div class="context-block">

{* DESIGN: Header START *}<div class="box-header"><div class="box-ml">

<h1 class="context-title">{'Orders (%count)'|i18n( 'design/admin/shop/orderlist',, hash( '%count', $order_list|count ) )}</h1>

{* DESIGN: Mainline *}<div class="header-mainline"></div>

{* DESIGN: Header END *}</div></div>

{* DESIGN: Content START *}<div class="box-ml"><div class="box-mr"><div class="box-content">

<form class="form-search" name="SearchOrderList" method="post" action={concat( '/owshop/orderlist', $view_parameters.offset|gt(0)|choose( '', concat( '/(offset)/', $view_parameters.offset ) ) )|ezurl}>

    <div class="well">
        <table class="table">
            <thead>
            <tr>
                <th>{'From'|i18n( 'owshop/orderlist' )} : </th>
                <th><input class="span2" id="dpd1" type="text" name="FromDateOrder" data-date-format="dd/mm/yyyy" value="{$FromDateOrder}"><span class="add-on"><i class="icon-th"></i></span></th>
                <th>{'To'|i18n( 'owshop/orderlist' )} : </th>
                <th><input class="span2" id="dpd2" type="text" name="ToDateOrder" data-date-format="dd/mm/yyyy" value="{$ToDateOrder}"><span class="add-on"><i class="icon-th"></i></span></th>
            </tr>
            <tr>
                <th>{'Status'|i18n( 'owshop/order' )}</th>
                <th>
                    <select name="StatusOrder" class="span2">
                        <option value=""></option>
                        {foreach $status_list as $status}
                            <option value="{$status.status_id}" {if eq($StatusOrder,$status.status_id)}selected{/if}>{$status.name}</option>
                        {/foreach}
                    </select>
                </th>
                <th colspan="2"></th>
            </tr>
            <tr>
                <th>{'Search'|i18n( 'owshop/orderlist' )} : </th>
                <th><input type="text" name="SearchOrder" class="span2" value="{$SearchOrder}"></th>
                <th colspan="2"></th>
            </tr>
            </thead>
        </table>
        <button type="submit" class="btn" name="FilterOrderButton">{'Filter'|i18n( 'owshop/orderlist' )}</button>
    </div>

</form>

{section show=$order_list}
<div class="context-toolbar">
<div class="button-left">
<p class="table-preferences">
{if eq( ezpreference( 'admin_orderlist_sortfield' ), 'user_name' )}
    <a href={'/user/preferences/set/admin_orderlist_sortfield/time/owshop/orderlist/'|ezurl}>{'Time'|i18n( 'design/admin/shop/orderlist' )}</a>
    <span class="current">{'Customer'|i18n( 'design/admin/shop/orderlist' )}</span>
{else}
    <span class="current">{'Time'|i18n( 'design/admin/shop/orderlist' )}</span>
    <a href={'/user/preferences/set/admin_orderlist_sortfield/user_name/owshop/orderlist/'|ezurl}>{'Customer'|i18n( 'design/admin/shop/orderlist' )}</a>
{/if}
</p>
</div>
<div class="button-right">
<p class="table-preferences">
{if eq( ezpreference( 'admin_orderlist_sortorder' ), 'desc' )}
    <a href={'/user/preferences/set/admin_orderlist_sortorder/asc/owshop/orderlist/'|ezurl}>{'Ascending'|i18n( 'design/admin/shop/orderlist' )}</a>
    <span class="current">{'Descending'|i18n( 'design/admin/shop/orderlist' )}</span>
{else}
    <span class="current">{'Ascending'|i18n( 'design/admin/shop/orderlist' )}</span>
    <a href={'/user/preferences/set/admin_orderlist_sortorder/desc/owshop/orderlist/'|ezurl}>{'Descending'|i18n( 'design/admin/shop/orderlist' )}</a>
{/if}
</p>
</div>
<div class="float-break"></div>
</div>
{def $currency = false()
     $locale = false()
     $symbol = false()}

<table class="list" cellspacing="0">
<tr>
    <th class="tight"><img src={'toggle-button-16x16.gif'|ezimage} width="16" height="16" alt="{'Invert selection.'|i18n( 'design/admin/shop/orderlist' )}" title="{'Invert selection.'|i18n( 'design/admin/shop/orderlist' )}" onclick="ezjs_toggleCheckboxes( document.orderlist, 'OrderIDArray[]' ); return false;" /></th>
    <th class="tight"></th>
    <th class="tight">{'ID'|i18n( 'design/admin/shop/orderlist' )}</th>
    <th class="wide">{'Customer'|i18n( 'design/admin/shop/orderlist' )}</th>
    <th class="tight">{'Total (ex. VAT)'|i18n( 'design/admin/shop/orderlist' )}</th>
    <th class="tight">{'Total (inc. VAT)'|i18n( 'design/admin/shop/orderlist' )}</th>
    <th class="wide">{'Time'|i18n( 'design/admin/shop/orderlist' )}</th>
    <th class="wide">{'Status'|i18n( 'design/admin/shop/orderlist' )}</th>
</tr>
{section var=Orders loop=$order_list sequence=array( bglight, bgdark )}

{set $currency = fetch( 'shop', 'currency', hash( 'code', $Orders.item.productcollection.currency_code ) )}
{if $currency}
    {set locale = $currency.locale
         symbol = $currency.symbol}
{else}
    {set locale = false()
         symbol = false()}
{/if}

<tr class="{$Orders.sequence}">
    <td><input type="checkbox" name="OrderIDArray[]" value="{$Orders.item.id}" title="{'Select order for removal.'|i18n( 'design/admin/shop/orderlist' )}" /></td>
    <td><a href={concat( '/owshop/orderedit/', $Orders.item.id, '/' )|ezurl}><img src={'edit.gif'|ezimage} width="16" height="16" alt="{'Edit'|i18n( 'owshop/order' )}" /></a></td>
    <td><a href={concat( '/owshop/orderview/', $Orders.item.id, '/' )|ezurl}>{$Orders.item.order_nr}</a></td>
    <td>
    {if is_null($Orders.item.account_name)}
        <s><i>{'( removed )'|i18n( 'design/admin/shop/orderlist' )}</i></s>
    {else}
        <a href={concat( '/owshop/customerorderview/', $Orders.item.user_id, '/', $Orders.item.account_email )|ezurl}>{$Orders.item.account_name|wash}</a>
    {/if}
    </td>
    

    {* NOTE: These two attribute calls are slow, they cause the system to generate lots of SQLs.
             The reason is that their values are not cached in the order tables *}
    <td class="number" align="right">{$Orders.item.total_ex_vat|l10n( 'currency', $locale, $symbol )}</td>
    <td class="number" align="right">{$Orders.item.total_inc_vat|l10n( 'currency', $locale, $symbol )}</td>

    <td>{$Orders.item.created|l10n( shortdatetime )}</td>
    <td>
    {let order_status_list=$Orders.status_modification_list}

    {section show=$order_status_list|count|gt( 0 )}
        {set can_apply=true()}
        <select name="StatusList[{$Orders.item.id}]">
        {section var=Status loop=$order_status_list}
            <option value="{$Status.item.status_id}"
                {if eq( $Status.item.status_id, $Orders.item.status_id )}selected="selected"{/if}>
                {$Status.item.name|wash}</option>
        {/section}
        </select>
    {section-else}
        {* Lets just show the name if we don't have access to change the status *}
        {$Orders.status_name|wash}
    {/section}

    {/let}
    </td>
</tr>
{/section}
</table>
{undef $currency $locale $symbol}
{section-else}
<div class="block">
<p>{'The order list is empty.'|i18n( 'design/admin/shop/orderlist' )}</p>
</div>
{/section}

<div class="context-toolbar">
{include name=navigator
         uri='design:navigator/google.tpl'
         page_uri='/owshop/orderlist'
         item_count=$order_list_count
         view_parameters=$view_parameters
         item_limit=$limit}
</div>

{* DESIGN: Content END *}</div></div></div>

<div class="controlbar">
{* DESIGN: Control bar START *}<div class="box-bc"><div class="box-ml">

<div class="block">
<div class="button-left">
{if $order_list}
    <input class="button" type="submit" name="ArchiveButton" value="{'Archive selected'|i18n( 'design/admin/shop/orderlist' )}" title="{'Archive selected orders.'|i18n( 'design/admin/shop/orderlist' )}" />
{else}
    <input class="button-disabled" type="submit" name="ArchiveButton" value="{'Archive selected'|i18n( 'design/admin/shop/orderlist' )}" disabled="disabled" />
{/if}
</div>
<div class="button-right">
    {if and( $order_list|count|gt( 0 ), $can_apply )}
    <input class="button" type="submit" name="SaveOrderStatusButton" value="{'Apply changes'|i18n( 'design/admin/shop/orderlist' )}" title="{'Click this button to store changes if you have modified any of the fields above.'|i18n( 'design/admin/shop/orderlist' )}" />
    {else}
    <input class="button-disabled" type="submit" name="SaveOrderStatusButton" value="{'Apply changes'|i18n( 'design/admin/shop/orderlist' )}" disabled="disabled" />
    {/if}
</div>
<div class="break"></div>

</div>

{* DESIGN: Control bar END *}</div></div>
</div>
</div>
</form>
{/let}
{literal}
<script type="text/javascript">

    var nowTemp = new Date();
    var now = new Date(nowTemp.getFullYear(), nowTemp.getMonth(), nowTemp.getDate(), 0, 0, 0, 0);

    var checkin = $('#dpd1').datepicker()
            .on('changeDate', function(ev) {
                if (ev.date.valueOf() > checkout.date.valueOf()) {
                    var newDate = new Date(ev.date)
                    newDate.setDate(newDate.getDate());
                    checkout.setValue(newDate);
                }
            checkin.hide();
        $('#dpd2')[0].focus();
    }).data('datepicker');

    var checkout = $('#dpd2').datepicker({
        onRender: function(date) {
            return date.valueOf() < checkin.date.valueOf() ? 'disabled' : '';
        }
    }).on('changeDate', function(ev) {
        checkout.hide();
    }).data('datepicker');

</script>
{/literal}