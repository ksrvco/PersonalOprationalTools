#!/bin/bash
# This script is a manual help for setup restricted chrome and brave in linux servers
# Goto this directory and also create this if not exists:  /etc/opt/chrome/policies/managed
# Create policies.json into /etc/opt/chrome/policies/managed :
# Sample content for this file:
{
        "AllowFileSelectionDialogs": false,
        "BlockExternalExtensions": true,
        "DeveloperToolsDisabled": true,
        "DownloadRestrictions": 3,
        "ExtensionInstallBlocklist": *,
        "IncognitoEnabled": false,
        "PrintPdfAsImageDefault": false,
        "PrintingEnabled": false,
        "SafeBrowsingEnabled": false,
        "ScreenCaptureAllowed": false,
        "URLBlocklist": file://*,chrome://*
}