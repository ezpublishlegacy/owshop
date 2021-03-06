<?php
/**
 * @copyright Copyright (C) 1999-2013 eZ Systems AS. All rights reserved.
 * @license http://ez.no/Resources/Software/Licenses/eZ-Business-Use-License-Agreement-eZ-BUL-Version-2.1 eZ Business Use License Agreement eZ BUL Version 2.1
 * @version 5.2.0
 * @package kernel
 */

/*!
  Contains all the error codes for the shop module.
  /deprecated Use eZError class constants instead
*/

eZDebug::writeWarning( "All the constants in " . __FILE__ . " are deprecated, use eZError class constants instead" );

/*!
 The object is not a product.
*/
define( 'EZ_ERROR_SHOP_OK', 0 );
define( 'EZ_ERROR_SHOP_NOT_A_PRODUCT', 1 );
define( 'EZ_ERROR_SHOP_BASKET_INCOMPATIBLE_PRODUCT_TYPE', 2 );
define( 'EZ_ERROR_SHOP_PREFERRED_CURRENCY_DOESNOT_EXIST', 3 );
define( 'EZ_ERROR_SHOP_PREFERRED_CURRENCY_INACTIVE', 4 );
?>
