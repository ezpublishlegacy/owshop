<?php
/**
 * File containing the OWDefaultConfirmOrderHandler class.
 *
 * @copyright Copyright (C) 1999-2013 eZ Systems AS. All rights reserved.
 * @license http://ez.no/Resources/Software/Licenses/eZ-Business-Use-License-Agreement-eZ-BUL-Version-2.1 eZ Business Use License Agreement eZ BUL Version 2.1
 * @version 5.2.0
 * @package kernel
 */

/*!
  \class OWDefaultConfirmOrderHandler ezdefaultconfirmorderhandler.php
  \brief The class OWDefaultConfirmOrderHandler does

*/

class OWDefaultConfirmOrderHandler
{
    /*!
     Constructor
    */
    function OWDefaultConfirmOrderHandler()
    {
    }

    function execute( $params = array() )
    {
        $ini = eZINI::instance();
        $sendOrderEmail = $ini->variable( 'ShopSettings', 'SendOrderEmail' );
        if ( $sendOrderEmail == 'enabled' )
        {
            $this->sendOrderEmail( $params );
        }
    }

    function sendOrderEmail( $params )
    {
        $ini = eZINI::instance();
        if ( isset( $params['order'] ) and
             isset( $params['email'] ) )
        {
            $order = $params['order'];
            $email = $params['email'];

            $tpl = eZTemplate::factory();
            $tpl->setVariable( 'order', $order );
            $templateResult = $tpl->fetch( 'design:shop/orderemail.tpl' );

            $subject = $tpl->variable( 'subject' );

            $mail = new eZMail();

            $emailSender = $ini->variable( 'MailSettings', 'EmailSender' );
            if ( !$emailSender )
                $emailSender = $ini->variable( "MailSettings", "AdminEmail" );

            if ( $tpl->hasVariable( 'content_type' ) )
                $mail->setContentType( $tpl->variable( 'content_type' ) );

            $mail->setReceiver( $email );
            $mail->setSender( $emailSender );
            $mail->setSubject( $subject );
            $mail->setBody( $templateResult );
            $mailResult = eZMailTransport::send( $mail );

            $email = $ini->variable( 'MailSettings', 'AdminEmail' );

            $mail = new eZMail();

            if ( $tpl->hasVariable( 'content_type' ) )
                $mail->setContentType( $tpl->variable( 'content_type' ) );

            $mail->setReceiver( $email );
            $mail->setSender( $emailSender );
            $mail->setSubject( $subject );
            $mail->setBody( $templateResult );
            $mailResult = eZMailTransport::send( $mail );
        }
    }
}

?>
