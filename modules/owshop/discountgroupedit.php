<?php
/**
 * @copyright Copyright (C) 1999-2013 eZ Systems AS. All rights reserved.
 * @license http://ez.no/Resources/Software/Licenses/eZ-Business-Use-License-Agreement-eZ-BUL-Version-2.1 eZ Business Use License Agreement eZ BUL Version 2.1
 * @version 5.2.0
 * @package kernel
 */

$module = $Params['Module'];
$discountGroupID = null;
if ( isset( $Params["DiscountGroupID"] ) )
    $discountGroupID = $Params["DiscountGroupID"];

if ( is_numeric( $discountGroupID ) )
{
    $discountGroup = eZDiscountRule::fetch( $discountGroupID );
}
else
{
    $discountGroup = eZDiscountRule::create();
    $discountGroupID = $discountGroup->attribute( "id" );
}

$http = eZHTTPTool::instance();
if ( $http->hasPostVariable( "DiscardButton" ) )
{
    $module->redirectTo( $module->functionURI( "discountgroup" ) . "/" );
    return;
}
if ( $http->hasPostVariable( "ApplyButton" ) )
{
    if ( $http->hasPostVariable( "discount_group_name" ) )
    {
        $name = $http->postVariable( "discount_group_name" );
    }
    $discountGroup->setAttribute( "name", $name );
    $discountGroup->store();
    $module->redirectTo( $module->functionURI( "discountgroup" ) . "/" );
    return;
}

$module->setTitle( "Editing discount group" );
$tpl = eZTemplate::factory();
$tpl->setVariable( "module", $module );
$tpl->setVariable( "discount_group", $discountGroup );

$Result = array();
$Result['content'] = $tpl->fetch( "design:shop/discountgroupedit.tpl" );

?>
