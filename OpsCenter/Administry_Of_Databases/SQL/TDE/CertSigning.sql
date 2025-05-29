-- Create a certificate
CREATE CERTIFICATE [CodeSigningCertificate] 
ENCRYPTION BY PASSWORD = 'Sooper$ecretp@ssword123' 
WITH EXPIRY_DATE = '2099-01-01', SUBJECT = 'Code Signing Cert';

-- Create a login from the certificate
CREATE LOGIN [CodeSigningLogin] FROM CERTIFICATE [CodeSigningCertificate];

-- Grant necessary permissions to the login
GRANT VIEW SERVER STATE TO [CodeSigningLogin];

-- Sign the stored procedure
ADD SIGNATURE TO dbo.TRG_OWNER_POLICY_UPD 
BY CERTIFICATE [CodeSigningCertificate] 
WITH PASSWORD = 'Sooper$ecretp@ssword123';
