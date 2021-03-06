<?php
/**
 * @copyright Copyright (C) 1999-2013 eZ Systems AS. All rights reserved.
 * @license http://ez.no/Resources/Software/Licenses/eZ-Business-Use-License-Agreement-eZ-BUL-Version-2.1 eZ Business Use License Agreement eZ BUL Version 2.1
 * @version 5.2.0
 * @package kernel
 */

$module = $Params["Module"];

$offset = $Params['Offset'];
$limit = 15;

$tpl = eZTemplate::factory();

$http = eZHTTPTool::instance();

$customerArray = eZOrder::customerList( $offset, $limit );

$customerCount = eZOrder::customerCount();

$tpl->setVariable( "customer_list", $customerArray );
$tpl->setVariable( "customer_list_count", $customerCount );
$tpl->setVariable( "limit", $limit );

$viewParameters = array( 'offset' => $offset );
$tpl->setVariable( "module", $module );
$tpl->setVariable( 'view_parameters', $viewParameters );

$path = array();
$path[] = array( 'text' => ezpI18n::tr( 'kernel/shop', 'Customer list' ),
                 'url' => false );

$Result = array();
$Result['path'] = $path;

$Result['content'] = $tpl->fetch( "design:shop/customerlist.tpl" );

?>
