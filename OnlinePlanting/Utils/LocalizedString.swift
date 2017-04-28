/**
 * ===============================================================================
 *
 * IBM Confidential
 *
 * OCO Source Materials
 *
 *
 *
 * (C) Copyright IBM Corp. 2015, 2016 All Rights Reserved.
 *
 * The source code for this program is not published or otherwise divested
 * of its trade secrets, irrespective of what has been deposited with
 * the U.S. Copyright office .
 *
 * ===============================================================================
 */

import Foundation

open class LocalizedString: NSObject {
    static let Exit:                    String = NSLocalizedString("Exit", comment: "Exit")
    static let comments:                String = NSLocalizedString("Comments", comment: "Comments")
    static let send:                    String = NSLocalizedString("Send", comment: "Send")
    static let update:                  String = NSLocalizedString("Update", comment: "Update")
    static let cancel:                  String = NSLocalizedString("Cancel", comment: "Cancel")
    static let resume:                  String = NSLocalizedString("Resume", comment: "Resume")
    static let downloadAll:             String = NSLocalizedString("Download All", comment: "Download All")
    static let continueStr:             String = NSLocalizedString("Continue", comment: "Continue")
    static let delete:                  String = NSLocalizedString("Delete", comment: "Delete")
    static let pause:                   String = NSLocalizedString("Pause", comment: "Pause")
    static let downloaded:              String = NSLocalizedString("Downloaded", comment: "Downloaded")
    static let downloadError:           String = NSLocalizedString("Download Error", comment: "Downloaded Error")
    static let wasDownloaded: String = NSLocalizedString("was downloaded", comment: "was downloaded")
    static let downloadBasicSuccess: String = NSLocalizedString("The basic contents of channel \"%@\" have been downloaded.", comment: "The basic contents of channel \"%@\" have been downloaded.")
    static let downloadFullSuccess: String = NSLocalizedString("All contents of channel \"%@\" have been downloaded.", comment: "All contents of channel \"%@\" have been downloaded.")
    static let downloadChannelSuccess:       String = NSLocalizedString("Channel successfully downloaded", comment: "Channel successfully downloaded")
    static let downloadViaWWAN: String  = NSLocalizedString("Warning: You are using cellular data, do you still want to download now?", comment: "Warning: You are using cellular data, do you still want to download now?")
    static let back:                    String = NSLocalizedString("Back", comment: "Back")
    static let open:                    String = NSLocalizedString("Open", comment: "Open")
    static let remove:                  String = NSLocalizedString("Remove", comment: "Remove")
    static let offlineMode:             String = NSLocalizedString("Offline Mode", comment: "Offline Mode")
    static let Menu:                    String = NSLocalizedString("Menu", comment: "Menu")
    static let unexpectedNetworkError:  String = NSLocalizedString("Unexpected network error", comment: "Unexpected network error")
    static let requestTimeout:          String = NSLocalizedString("Request Timed Out", comment: "Request Timed Out")
    static let enterUsernameMsg:        String = NSLocalizedString("Please enter your email address.", comment: "Please enter your email address.")
    static let enterPwdMsg:             String = NSLocalizedString("Please enter your password.", comment: "Please enter your password.")
    static let enterUsernamePwdMsg:     String = NSLocalizedString("Please enter your email address and password.", comment: "Please enter your email address and password.")
    static let checkUsernameAndPwd:     String = NSLocalizedString("Invalid email address or password", comment: "Invalid email address or password")
    static let authorityErrorMsg:       String = NSLocalizedString("Your company does not have permission to use the Client Vantage mobile version.", comment: "Your company does not have permission to use the Client Vantage mobile version.")
    static let password:                String = NSLocalizedString("Password", comment: "Password")
    static let about:                   String = NSLocalizedString("About", comment: "About")
    static let versionM:                String = NSLocalizedString("Version", comment: "Version")
    static let ok:                      String = NSLocalizedString("OK", comment: "OK")
    static let logout:                  String = NSLocalizedString("Log out", comment: "Log out")
    static let login:                   String = NSLocalizedString("Log In", comment: "Log In")
    static let loginSmail:                   String = NSLocalizedString("Log in", comment: "Log in")
    static let privacyPolicy:           String = NSLocalizedString("Privacy Policy", comment: "Privacy Policy")
    static let contactSupport:          String = NSLocalizedString("Contact Support", comment: "Contact Support")
    
    //Please add more String HERE
    static let serverErrororNetworkError: String =  NSLocalizedString("Server or network error.", comment: "Server or network error.")
    static let pleaseTrytoDownloadLater: String = NSLocalizedString("Please try to download it later", comment: "Please try to download it later.")
    static let noFavsTips:           String = NSLocalizedString("No favorite channel", comment: "No favorite channel")
    static let noDownloadTips:           String = NSLocalizedString("No downloaded channel", comment: "No downloaded channel")
    
    static let manage:                  String = NSLocalizedString("Manage", comment: "Manage")
    static let removeChannelFromFav:    String = NSLocalizedString("Remove %@ channel(s) from Favorites.", comment: "Remove %@ channel(s) from Favorites.")
    static let manageFav:               String = NSLocalizedString("Manage Favorites", comment: "Manage Favorites")
    static let numOfFavSelectedOne:        String = NSLocalizedString("1 channel is selected", comment: "1 channel is selected")
    static let numOfFavSelectedMore:        String = NSLocalizedString("%@ channels are selected", comment: "%@ channels are selected")
    static let channels:                String = NSLocalizedString("Channels", comment: "Channels")
    static let favorites:                String = NSLocalizedString("Favorites", comment: "Favorites")
    static let search:                String = NSLocalizedString("Search", comment: "Search")
    
    // profile
    static let profileTitle:            String = NSLocalizedString("Profile", comment: "Profile")
    static let profileNoti:             String = NSLocalizedString("NOTIFICATIONS", comment: "NOTIFICATIONS")
    static let profileSetting:          String = NSLocalizedString("SETTINGS", comment: "SETTINGS")
    static let profileSupport:          String = NSLocalizedString("SUPPORT", comment: "SUPPORT")
    
    static let emailNoti:               String = NSLocalizedString("Email Notification", comment: "Email Notification")
    static let touchID:                 String = NSLocalizedString("Touch ID", comment: "Touch ID")
    static let clearCache:              String = NSLocalizedString("Clear Cache", comment: "Clear Cache")
    static let clear:                   String = NSLocalizedString("Clear", comment: "Clear")
    static let Notice:                  String = NSLocalizedString("Notice", comment: "Notice")
    static let emailNotiFailure:        String = NSLocalizedString("Fail to set email notification", comment: "Fail to set email notification")
    
    // help
    static let helpTitle:               String = NSLocalizedString("Help", comment: "Help")
    static let helpSuggestions:         String = NSLocalizedString("Please leave your comments or suggestions here.", comment: "Please leave your comments or suggestions here.")

    // comment
    static let closeButton:             String = NSLocalizedString("Close", comment: "Close")
    static let commentPlaceholderLabel: String = NSLocalizedString("Add your comments", comment: "Add your comments")
    static let commentSendFailure:      String = NSLocalizedString("Failed to add comments.", comment: "Failed to add comments.")
    static let commentDeleteConfirm:    String = NSLocalizedString("Are you sure you want to delete your comment?", comment: "Are you sure you want to delete your comment?")
    static let commentDeleteAlert:      String = NSLocalizedString("Delete comment", comment: "Delete comment")

    static let downloadBasicContentTitle: String = NSLocalizedString("Download basic contents", comment: "")
    static let updateBasicContentTitle: String = NSLocalizedString("Update basic contents", comment: "")
    static let startDownloadBasicContent: String = NSLocalizedString("Start to download the basic contents of this channel.", comment: "Start to download the basic contents of this channel.")
    static let startUpdateBasicContent: String = NSLocalizedString("Start to update the basic contents of this channel.", comment: "Start to update the basic contents of this channel.")
    static let downloadingBasicContentTitle: String = NSLocalizedString("Downloading basic contents", comment: "")
    static let pausedBasicContentTitle: String = NSLocalizedString("Basic contents download paused", comment: "")
    static let deleteDownloadedBasicContentTitle: String = NSLocalizedString("Basic contents downloaded", comment: "")
    static let downloadBasicContentDescription: String = NSLocalizedString("Basic contents includes text and pictures.", comment: "")
    static let downloadAllContentTitle: String = NSLocalizedString("Download all contents", comment: "")
    static let updateAllContentTitle: String = NSLocalizedString("Update all contents", comment: "")
    static let startDownloadAllContent: String = NSLocalizedString("Start to download entire channel contents.", comment: "Start to update entire channel contents")
    static let startUpdateAllContent: String = NSLocalizedString("Start to update content of this channel.", comment: "Start to update content of this channel.")
    static let downloadingAllContentTitle: String = NSLocalizedString("Downloading entire channel content", comment: "")
    static let pausedAllContentTitle: String = NSLocalizedString("Full download content paused.", comment: "")
    static let deleteDownloadedAllContentTitle: String = NSLocalizedString("All contents downloaded", comment: "")
    static let downloadAllContentDescription: String = NSLocalizedString("All contents includes text, pictures, videos and document files.", comment: "")
    
    static let notifyMe: String = NSLocalizedString("Notify Me of Changes", comment: "")
    static let addFavorite: String = NSLocalizedString("Add to Favorites", comment: "")
    static let setHomePage: String = NSLocalizedString("Set as Homepage", comment: "")
    static let featured: String = NSLocalizedString("Featured", comment: "")
    static let noComments: String = NSLocalizedString("No comments", comment: "No comments")
    
    //login in
    static let usernamePlaceHolder:        String = NSLocalizedString("Email", comment: "Email address")
    static let newPasswordPlaceHolder:        String = NSLocalizedString("Create a new password", comment: "Create a new password")
    static let confirmPasswordPlaceHolder:        String = NSLocalizedString("Confirm your new password", comment: "Confirm your new password")
    static let authenticatingLoading:        String = NSLocalizedString("Authenticating", comment: "Authenticating")
    static let initializingConnection:        String = NSLocalizedString("Initializing connection", comment: "Initializing connection")
    static let validatingInformation:        String = NSLocalizedString("Validating information", comment: "Validating information")
    static let savingPasswordLoading:        String = NSLocalizedString("Saving password...", comment: "Saving password...")
    static let loading:        String = NSLocalizedString("Loading", comment: "Loading")
    static let resetPasswordTitle:        String = NSLocalizedString("Reset Password", comment: "Reset Password")
    static let openTouchID:        String = NSLocalizedString("Do you want to set up Touch ID?", comment: "Do you want to set up Touch ID?")
    static let wrongInforNewPassword:        String = NSLocalizedString("Please enter your new password.", comment: "Please enter your new password.")
    static let wrongInforConfirmPassword:        String = NSLocalizedString("Please confirm your new password.", comment: "Please confirm your new password.")
    static let wrongInforDidNotMatch:        String = NSLocalizedString("The passwords entered do not match.", comment: "The passwords entered do not match.")
    static let invalidNewPassword:        String = NSLocalizedString("Password must follow the password policy.", comment: "Password must follow the password policy.")
    static let done:        String = NSLocalizedString("Done", comment: "Done")
    static let privacyPolicyHighlights:        String = NSLocalizedString("IBM Online Privacy Statement Highlights", comment: "IBM Online Privacy Statement Highlights")
    static let w3idLogin:        String = NSLocalizedString("Log In With Your IBM w3id", comment: "Log in with your IBM w3id")
    static let reset:        String = NSLocalizedString("Reset", comment: "Reset")
    static let cancelResetPassword:        String = NSLocalizedString("Cancel Reset Password", comment: "Cancel Reset Password")
    static let cancelResetPasswordContent:        String = NSLocalizedString("Click 'Reset' to continue to reset your password; otherwise, you will be logged out from the application now.", comment: "Click 'Reset' to continue to reset your password; otherwise, you will be logged out from the application now.")
    static let passwordAboutToExpired:        String = NSLocalizedString("Password is about to expire.", comment: "Password is about to expire.")
    static let passwordAboutToExpiredContent:        String = NSLocalizedString("Password expiration warning…you have %@ times left to log in with current password. You can update it from your profile later, or do it now. Update now?", comment: "Password expiration warning…you have %@ times left to log in with current password. You can update it from your profile later, or do it now. Update now?")
    static let passwordExpiredSoonContent:        String = NSLocalizedString("Your password will expire on %@.  Do you want to change now?", comment: "Your password will expire on %@.  Do you want to change now?")
    static let passwordPolicy:           String = NSLocalizedString("Password Policy", comment: "Password Policy")
    
    static let htmlStylePrivacyPolicy: String = NSLocalizedString("htmlStylePrivacyPolicy", comment: "")
    
    static let htmlPasswordPolicyContent: String = NSLocalizedString("htmlPasswordPolicyContent", comment: "")
    
    //Downloads
    static let downloads:               String = NSLocalizedString("Downloads", comment: "Downloads")
    static let manageDownloads:         String = NSLocalizedString("Manage Downloads", comment: "Manage Downloads")
    static let removeChannelFromDownloads:    String = NSLocalizedString("Remove %@ channel(s) from Downloads.", comment: "Remove %@ channel(s) from Downloads.")
    
    //Channels
    static let allChannelsCount:        String = NSLocalizedString("All Channels(%@)", comment: "All Channels(%@)")
    static let updateAlert:             String = NSLocalizedString("Channel has been updated since last download, do you want to update your downloaded content?", comment: "Channel has been updated since last download, do you want to update your downloaded content?")
    static let noLater:                 String = NSLocalizedString("No, later", comment: "No, later")
    static let noChannels:               String = NSLocalizedString("No Channels", comment: "No Channels")
    
    //Common
    static let operationSuccessful:     String = NSLocalizedString("The operation was successful.", comment: "The operation was successful.")
    static let operationFailed:         String = NSLocalizedString("The operation failed.", comment: "The operation failed.")
    static let yes: String = NSLocalizedString("Yes", comment: "Yes")
    static let no: String = NSLocalizedString("No", comment: "No")
    
    static let switchToOnlineMode: String = NSLocalizedString("The network is available now, do you want to log in to view the online content?", comment: "The network is available now, do you want to log in to view the online content?")
    
    static let channelsCount: String = NSLocalizedString("Channels (%@)", comment: "Channels (%@)")
    static let pagesCount: String = NSLocalizedString("Pages (%@)", comment: "Pages (%@)")
    static let contentCount: String = NSLocalizedString("Contents (%@)", comment: "Contents (%@)")
    static let recentSearch: String = NSLocalizedString("Recent searches", comment: "Recent searches")
    static let noSearch: String = NSLocalizedString("No search result, try other words.", comment: "No search result, try other words.")
    static let errSearch: String = NSLocalizedString("Search failed, try again.", comment: "Search failed, try again.")
    static let aboutDescription:        String = NSLocalizedString("Description", comment: "Description")
    static let aboutPolicy:             String = NSLocalizedString("Policy", comment: "Policy")
    static let aboutTerms:              String = NSLocalizedString("Terms of Use", comment: "Terms of Use")
    static let aboutContacts:           String = NSLocalizedString("Contacts", comment: "Contacts")
    static let whatsNew:                String = NSLocalizedString("What's New", comment: "What's New")

    static let jumpTip: String = NSLocalizedString("Leaving channel %@, now going to channel %@.", comment: "Leaving channel %@, now going to channel %@.")
    // Side Menu
    static let backToCrossChannel: String = NSLocalizedString("Back to %@ channel", comment: "Back to %@ channel")
    static let fetchFile: String = NSLocalizedString("Fetching %@, please wait...", comment: "Fetching %@, please wait...")
    static let noConnectionLogin: String = NSLocalizedString("No internet connection, please try again when you have a connection.", comment: "No internet connection, please try again when you have a connection.")
    
    //whats new
    static let whatsnewGetStarted: String = NSLocalizedString("Get Started", comment: "Get Started")
    static let whatsnewSkip: String = NSLocalizedString("Skip", comment: "Skip")
    
    static let messageSucces: String = NSLocalizedString("Your message has been sent successfully.", comment: "Your message has been sent successfully.")
    static let messageFailed: String = NSLocalizedString("Failed to send message.", comment: "Failed to send message.")
    static let selectAplatform: String = NSLocalizedString("Select a platform", comment: "Select a platform")
    static let passwordPolicy1: String = NSLocalizedString("1. Must be at least 8 positions in length.", comment: "item1")
    static let passwordPolicy2: String = NSLocalizedString("2. Must contain a mix of alphabetic and non-alphabetic characters(numbers, punctuation or special characters) or a mix of at least two types of non-alphabetic characters.", comment: "item2")
    static let passwordPolicy3: String = NSLocalizedString("3. Cannot contain the userid as part of the password.", comment: "item3")
    static let passwordPolicy4: String = NSLocalizedString("4. Must be changed at least once every 13 weeks.", comment: "item4")
    static let passwordPolicy5: String = NSLocalizedString("5. Must have a minimum password age of 1 day before it can be changed again.", comment: "item5")
    static let passwordPolicy6: String = NSLocalizedString("6. Cannot be reused until after at least 8 iterations.", comment: "item6")
    // app install
    static let appInstallTitle: String = NSLocalizedString("App Install Required", comment: "App Install Required")
    static let appInstallMsg: String = NSLocalizedString("Please install this app from the IBM App Store first.", comment: "Please install this app from the IBM App Store first.")

   }
