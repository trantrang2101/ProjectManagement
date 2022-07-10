/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Model.uuid;

import java.text.SimpleDateFormat;
import java.time.Instant;
import java.time.LocalDate;
import java.util.Date;
import java.util.Properties;
import java.util.UUID;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import uuid.UuidCreator;

/**
 *
 * @author win
 */
public class DecodeUUID {

//    public static void main(String[] args) {
//        UUID uuid = UuidCreator.getTimeBased();
//        SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
//        System.out.println(formatter.format(getInstantFromUUID(uuid)));
//    }
    public static void main(String[] args) {

        String username = "eduproject.edu.vn@gmail.com";
        String password = "swp391SE1619";

        Properties prop = new Properties();
        prop.put("mail.smtp.host", "smtp.gmail.com");
        prop.put("mail.smtp.port", "587");
        prop.put("mail.smtp.auth", "true");
        prop.put("mail.smtp.starttls.enable", "true");
        prop.put("mail.smtp.starttls.required", "true");

        Session session = Session.getInstance(prop,
                new javax.mail.Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        });

        try {

            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(username));
            message.addRecipient(Message.RecipientType.TO, new InternetAddress("datdatle2002@gmail.com"));
            message.setSubject("Testing Gmail TLS");
            message.setText("Dear Mail Crawler,"
                    + "\n\n Please do not spam my email!");

            Transport.send(message);

            System.out.println("Done");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    private static final long NUM_HUNDRED_NANOS_IN_A_SECOND = 10_000_000L;

    private static final long NUM_HUNDRED_NANOS_FROM_UUID_EPOCH_TO_UNIX_EPOCH = 122_192_928_000_000_000L;

    /**
     * Extracts the Instant (with the maximum available 100ns precision) from
     * the given time-based (version 1) UUID.
     *
     * @return the {@link Instant} extracted from the given time-based UUID
     * @throws UnsupportedOperationException If this UUID is not a version 1
     * UUID
     */
    public static Date getInstantFromUUID(final UUID uuid) {
        final long hundredNanosSinceUnixEpoch = uuid.timestamp() - NUM_HUNDRED_NANOS_FROM_UUID_EPOCH_TO_UNIX_EPOCH;
        final long secondsSinceUnixEpoch = hundredNanosSinceUnixEpoch / NUM_HUNDRED_NANOS_IN_A_SECOND;
        final long nanoAdjustment = ((hundredNanosSinceUnixEpoch % NUM_HUNDRED_NANOS_IN_A_SECOND) * 100);
        return Date.from(Instant.ofEpochSecond(secondsSinceUnixEpoch, nanoAdjustment));
    }
}
