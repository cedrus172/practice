--1.
CREATE DATABASE MyBlog
use MyBlog

--2 , 3
CREATE TABLE Users(UserID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
                   UserName varchar(20) NOT NULL,
				   Password varchar(30) NOT NULL,
				   Email varchar(30) NOT NULL UNIQUE,
				   Address nvarchar(200))

CREATE TABLE Posts(PostID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
				   Title nvarchar(200) NOT NULL,
				   Content nvarchar(MAX) NOT NULL,
				   Tag nvarchar(100) NULL,
				   Status bit,
				   CreateTime datetime DEFAULT(getdate()),
				   UpdateTime datetime,
				   UserID int,
				   FOREIGN KEY(UserID) REFERENCES Users(UserID) )

CREATE TABLE Comments(CommentID int IDENTITY(1,1) NOT NULL PRIMARY KEY,
					  Content nvarchar(500),
					  Status bit,
					  CreateTime datetime DEFAULT(getdate()),
					  Author nvarchar(30),
					  Email varchar(50) NOT NULL,
					  PostID int,
					  FOREIGN KEY(PostID) REFERENCES Posts(PostID))

CREATE INDEX IX_UserName
ON Users(UserName)

INSERT INTO Users VALUES ('cedrus','123123','abc@gmail.com','Cau Giay')
INSERT INTO Users VALUES ('cedrus2','1231231','cedrus2@gmail.com','Thanh Xuan')
INSERT INTO Users VALUES ('cedrus3','1231221','cedrus3@gmail.com','Nam Dinh')

INSERT INTO Posts VALUES ('Hello co giao', N'Hello hello ahhahaha', 'Social', 'true', getdate(),getdate(), 1 )
INSERT INTO Posts VALUES ('Hello co giao2', N'Hello hello ahhahaha2', 'hello2', 'true', getdate(),getdate(), 2 )
INSERT INTO Posts VALUES ('Hello co giao3', N'Hello hello ahhahaha3', 'hello3', 'true', getdate(),getdate(), 3 )

INSERT INTO Comments VALUES ('Chao tat ca cac ban','true', getdate()+5, 'Cedrus','cedrusisme@gmail.com', 1)
INSERT INTO Comments VALUES ('Hello anh em','true', getdate()-4, 'Canhars','canhars@gmail.com', 2)
INSERT INTO Comments VALUES ('Chao tat ca cac ban lan 2','true', getdate()-40, 'Hunghoi','abc@gmail.com', 3)

SELECT * FROM Posts WHERE Tag = 'Social'

SELECT * FROM Posts WHERE UserID in (SELECT UserID From Users WHERE Email='abc@gmail.com')

SELECT COUNT(*) as Count FROM Comments

CREATE VIEW v_NewPost AS
SELECT  TOP 2 dbo.Posts.Title, dbo.Users.UserName, dbo.Posts.CreateTime
FROM            dbo.Posts INNER JOIN
                         dbo.Users ON dbo.Posts.UserID = dbo.Users.UserID
ORDER BY dbo.Posts.CreateTime DESC

CREATE Procedure sp_GetComment 
	@PostID int
AS
BEGIN
	select * from Comments where PostID = @PostID
END

GO

CREATE TRIGGER tg_UpdateTime
ON Posts
AFTER  INSERT,UPDATE AS
BEGIN
   UPDATE Posts 
   SET UpdateTime = GETDATE()
   FROM Posts
   JOIN deleted ON Posts.PostID = deleted.PostID    
END