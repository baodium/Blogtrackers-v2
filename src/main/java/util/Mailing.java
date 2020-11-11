<<<<<<< HEAD
/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package util;
import javax.mail.*;
import javax.mail.internet.*;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import javax.servlet.http.HttpSession;
/**
 *
 * @author Shamanth
 */
public class Mailing {
    


public static void postMail( String[] recipients, String subject, String message ) throws MessagingException
{
//    boolean debug = false;
//    String SSL_FACTORY = "javax.net.ssl.SSLSocketFactory";
//    String SMTP_PORT = "465";
//     //Set the host smtp address
//     Properties props = new Properties();
//     props.put("mail.smtp.host", "smtp.gmail.com");
//     //props.put("mail.smtp.host", "localhost");
//     props.put("mail.smtp.auth", "true");
//     props.put("mail.debug", "false");
//     props.put("mail.smtp.port", SMTP_PORT);
//     props.put("mail.smtp.socketFactory.port", SMTP_PORT);
//     props.put("mail.smtp.socketFactory.class", SSL_FACTORY);
//     props.put("mail.smtp.socketFactory.fallback", "false");
//    // create some properties and get the default Session
//     //Session session = Session.getDefaultInstance(props);
//    Session session = Session.getDefaultInstance(props,new javax.mail.Authenticator(){
//            @Override
//    protected PasswordAuthentication getPasswordAuthentication() {
//    return new PasswordAuthentication("blogtrackers", "CosmosIsSuchAGreatResearchLab1!");
//    }
//    });
//    session.setDebug(debug);
//    Transport tp = session.getTransport("smtp");
//    tp.connect();
//    // create a message
//    Message msg = new MimeMessage(session);
//
//    // set the from and to address
//    InternetAddress addressFrom = new InternetAddress("blogtrackers@gmail.com");
//    msg.setFrom(addressFrom);
//    //
//
//    InternetAddress[] addressTo = new InternetAddress[recipients.length]; 
//    for (int i = 0; i < recipients.length; i++)
//    {
//        addressTo[i] = new InternetAddress(recipients[i]);
//    }
//    msg.setRecipients(Message.RecipientType.TO, addressTo);
//    // Optional : You can also set your custom headers in the Email if you Want
//    msg.addHeader("MyHeaderName", "myHeaderValue");
//
//    // Setting the Subject and Content Type
//    msg.setSubject(subject);
//    msg.setContent(message, "text/html");
//    Transport.send(msg);
	
	
	
	//Get properties object    
    Properties props = new Properties();    
//    props.put("mail.smtp.host", "smtp.gmail.com");    
//    props.put("mail.smtp.socketFactory.port", "465");    
//    props.put("mail.smtp.socketFactory.class",    
//              "javax.net.ssl.SSLSocketFactory");    
    props.put("mail.smtp.ssl.enable", "true");
    props.put("mail.smtp.host", "smtp.gmail.com");
    props.put("mail.smtp.auth", "true");
    props.put("mail.debug", "true");
    props.put("mail.smtp.port", "465");

    props.put("mail.smtp.starttls.enable", "true");

    props.put("mail.smtp.socketFactory.port", "465");
    props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
    props.put("mail.smtp.socketFactory.fallback", "false"); 
    //get Session   
    Session session = Session.getDefaultInstance(props,    
     new javax.mail.Authenticator() {    
     protected PasswordAuthentication getPasswordAuthentication() {    
//     return new PasswordAuthentication("blogtrackers@gmail.com", "CosmosIsSuchAGreatResearchLab1!");  
    	 return new PasswordAuthentication("btrackerdemo@gmail.com", "DemoAccount1!"); 
     }    
    });    
    //compose message    
    try {    
     MimeMessage msg = new MimeMessage(session);    
     
     for (int i = 0; i < recipients.length; i++)
       {
    	 msg.addRecipient(Message.RecipientType.TO,new InternetAddress(recipients[i]));
    	 msg.setSubject(subject);
    	 msg.setContent(message, "text/html");
    	 Transport.send(msg);    
       }
     
//     msg.addRecipient(Message.RecipientType.TO,new InternetAddress(recipients));    
//     msg.setSubject(sub);    
//     msg.setText(msg);    
     //send message  
     
     System.out.println("message sent successfully");    
    } catch (MessagingException e) {throw new RuntimeException(e);}    
}

}
=======
/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package util;
import javax.mail.*;
import javax.mail.internet.*;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import javax.servlet.http.HttpSession;
/**
 *
 * @author Shamanth
 */
public class Mailing {
    


public static void postMail( String[] recipients, String subject, String message ) throws MessagingException
{
//    boolean debug = false;
//    String SSL_FACTORY = "javax.net.ssl.SSLSocketFactory";
//    String SMTP_PORT = "465";
//     //Set the host smtp address
//     Properties props = new Properties();
//     props.put("mail.smtp.host", "smtp.gmail.com");
//     //props.put("mail.smtp.host", "localhost");
//     props.put("mail.smtp.auth", "true");
//     props.put("mail.debug", "false");
//     props.put("mail.smtp.port", SMTP_PORT);
//     props.put("mail.smtp.socketFactory.port", SMTP_PORT);
//     props.put("mail.smtp.socketFactory.class", SSL_FACTORY);
//     props.put("mail.smtp.socketFactory.fallback", "false");
//    // create some properties and get the default Session
//     //Session session = Session.getDefaultInstance(props);
//    Session session = Session.getDefaultInstance(props,new javax.mail.Authenticator(){
//            @Override
//    protected PasswordAuthentication getPasswordAuthentication() {
//    return new PasswordAuthentication("blogtrackers", "CosmosIsSuchAGreatResearchLab1!");
//    }
//    });
//    session.setDebug(debug);
//    Transport tp = session.getTransport("smtp");
//    tp.connect();
//    // create a message
//    Message msg = new MimeMessage(session);
//
//    // set the from and to address
//    InternetAddress addressFrom = new InternetAddress("blogtrackers@gmail.com");
//    msg.setFrom(addressFrom);
//    //
//
//    InternetAddress[] addressTo = new InternetAddress[recipients.length]; 
//    for (int i = 0; i < recipients.length; i++)
//    {
//        addressTo[i] = new InternetAddress(recipients[i]);
//    }
//    msg.setRecipients(Message.RecipientType.TO, addressTo);
//    // Optional : You can also set your custom headers in the Email if you Want
//    msg.addHeader("MyHeaderName", "myHeaderValue");
//
//    // Setting the Subject and Content Type
//    msg.setSubject(subject);
//    msg.setContent(message, "text/html");
//    Transport.send(msg);
	
	
	
	//Get properties object    
    Properties props = new Properties();    
//    props.put("mail.smtp.host", "smtp.gmail.com");    
//    props.put("mail.smtp.socketFactory.port", "465");    
//    props.put("mail.smtp.socketFactory.class",    
//              "javax.net.ssl.SSLSocketFactory");    
    props.put("mail.smtp.ssl.enable", "true");
    props.put("mail.smtp.host", "smtp.gmail.com");
    props.put("mail.smtp.auth", "true");
    props.put("mail.debug", "true");
    props.put("mail.smtp.port", "465");

    props.put("mail.smtp.starttls.enable", "true");

    props.put("mail.smtp.socketFactory.port", "465");
    props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
    props.put("mail.smtp.socketFactory.fallback", "false"); 
    //get Session   
    Session session = Session.getDefaultInstance(props,    
     new javax.mail.Authenticator() {    
     protected PasswordAuthentication getPasswordAuthentication() {    
//     return new PasswordAuthentication("blogtrackers@gmail.com", "CosmosIsSuchAGreatResearchLab1!");  
    	 return new PasswordAuthentication("btrackerdemo@gmail.com", "DemoAccount1!"); 
     }    
    });    
    //compose message    
    try {    
     MimeMessage msg = new MimeMessage(session);    
     
     for (int i = 0; i < recipients.length; i++)
       {
    	 msg.addRecipient(Message.RecipientType.TO,new InternetAddress(recipients[i]));
    	 msg.setSubject(subject);
    	 msg.setContent(message, "text/html");
    	 Transport.send(msg);    
       }
     
//     msg.addRecipient(Message.RecipientType.TO,new InternetAddress(recipients));    
//     msg.setSubject(sub);    
//     msg.setText(msg);    
     //send message  
     
     System.out.println("message sent successfully");    
    } catch (MessagingException e) {throw new RuntimeException(e);}    
}

}
>>>>>>> 1f92e31eaa52c61d7b7996ab5ec5a9cf214df293
