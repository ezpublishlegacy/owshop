<?php
/**
 * @copyright Copyright (C) 1999-2013 eZ Systems AS. All rights reserved.
 * @license http://ez.no/Resources/Software/Licenses/eZ-Business-Use-License-Agreement-eZ-BUL-Version-2.1 eZ Business Use License Agreement eZ BUL Version 2.1
 * @version 5.2.0
 * @package kernel
 */

$http = eZHTTPTool::instance();
$basket = eZBasket::currentBasket();
$module = $Params['Module'];

$quantity = (int)$module->NamedParameters["Quantity"];
if ( !is_numeric( $quantity ) or $quantity <= 0 )
{
    $quantity = 1;
}
// Verify the ObjectID input
if ( !is_numeric( $ObjectID ) )
    return $module->handleError( eZError::KERNEL_NOT_AVAILABLE, 'kernel' );

// Check if the object exists on disc
if ( !eZContentObject::exists( $ObjectID ) )
    return $module->handleError( eZError::KERNEL_NOT_AVAILABLE, 'kernel' );

// Check if the user can read the object
$object = eZContentObject::fetch( $ObjectID );
if ( !$object->canRead() )
    return $Module->handleError( eZError::KERNEL_ACCESS_DENIED, 'kernel', array( 'AccessList' => $object->accessList( 'read' ) ) );

// Check if the object has a price datatype, if not it cannot be used in the basket
$error = $basket->canAddProduct( $object );
if ( $error !== eZError::SHOP_OK )
    return $Module->handleError( $error, 'owshop' );

$OptionList = $http->sessionVariable( "AddToBasket_OptionList_" . $ObjectID );

$operationResult = eZOperationHandler::execute( 'owshop', 'addtobasket', array( 'basket_id' => $basket->attribute( 'id' ),
                                                                              'object_id' => $ObjectID,
                                                                              'quantity' => $quantity,
                                                                              'option_list' => $OptionList ) );

switch( $operationResult['status'] )
{
    case eZModuleOperationInfo::STATUS_HALTED:
    {
        if ( isset( $operationResult['redirect_url'] ) )
        {
            $module->redirectTo( $operationResult['redirect_url'] );
            return;
        }
        else if ( isset( $operationResult['result'] ) )
        {
            $result = $operationResult['result'];
            $resultContent = false;
            if ( is_array( $result ) )
            {
                if ( isset( $result['content'] ) )
                {
                    $resultContent = $result['content'];
                }
                if ( isset( $result['path'] ) )
                {
                    $Result['path'] = $result['path'];
                }
            }
            else
            {
                $resultContent = $result;
            }
            $Result['content'] = $resultContent;
            return $Result;
       }
    }break;
    case eZModuleOperationInfo::STATUS_CANCELLED:
    {
        if ( isset( $operationResult['reason'] ) &&  $operationResult['reason'] == 'validation' )
        {
            $http = eZHTTPTool::instance();
            $http->setSessionVariable( "BasketError", $operationResult['error_data'] );
            $module->redirectTo( $module->functionURI( "basket" ) . "/(error)/options" );
            return;
        }
        else if ( isset( $operationResult['result'] ) )
        {
            $result = $operationResult['result'];
            $resultContent = false;
            if ( is_array( $result ) )
            {
                if ( isset( $result['content'] ) )
                {
                    $resultContent = $result['content'];
                }
                if ( isset( $result['path'] ) )
                {
                    $Result['path'] = $result['path'];
                }
            }
            else
            {
                $resultContent = $result;
            }
            $Result['content'] = $resultContent;
            return $Result;
       }
    }break;

}


$ini = eZINI::instance();
if ( $ini->variable( 'ShopSettings', 'RedirectAfterAddToBasket' ) == 'reload' )
    $module->redirectTo( $http->sessionVariable( "FromPage" ) );
else
    $module->redirectTo( "/owshop/basket/" );

?>
