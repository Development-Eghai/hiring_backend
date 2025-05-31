-- recruitingdb_postgres.sql
-- PostgreSQL 16 compatible schema

CREATE TABLE applications (
  "ApplicationID" SERIAL PRIMARY KEY,
  "CandidateID" INTEGER NOT NULL,
  "RequisitionID" INTEGER NOT NULL,
  "Status" VARCHAR(32) DEFAULT 'Applied' CHECK ("Status" IN ('Applied','Screened','Interview Scheduled','Selected','Rejected')),
  "SubmittedDate" TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE candidates (
  "CandidateID" SERIAL PRIMARY KEY,
  "Name" VARCHAR(191) NOT NULL,
  "Email" VARCHAR(191) NOT NULL UNIQUE,
  "Resume" TEXT,
  "ProfileCreated" TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE interview (
  "InterviewID" SERIAL PRIMARY KEY,
  "ApplicationID" INTEGER NOT NULL,
  "InterviewerID" INTEGER NOT NULL,
  "InterviewDate" DATE,
  "Feedback" TEXT,
  "Rating" INTEGER
);

CREATE TABLE jobposting (
  "PostingID" SERIAL PRIMARY KEY,
  "RequisitionID" INTEGER NOT NULL,
  "PostingType" VARCHAR(32) NOT NULL CHECK ("PostingType" IN ('Intranet','External','Private')),
  "PostingStatus" VARCHAR(32) DEFAULT 'Pending' CHECK ("PostingStatus" IN ('Pending','Posted','Closed')),
  "StartDate" DATE,
  "EndDate" DATE
);

CREATE TABLE jobrequisition (
  "RequisitionID" SERIAL PRIMARY KEY,
  "PositionTitle" VARCHAR(191) NOT NULL,
  "HiringManagerID" INTEGER NOT NULL,
  "Status" VARCHAR(32) DEFAULT 'Draft' CHECK ("Status" IN ('Draft','Pending Approval','Approved','Posted','Closed')),
  "CreatedDate" TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE offerletter (
  "OfferID" SERIAL PRIMARY KEY,
  "CandidateID" INTEGER NOT NULL,
  "RequisitionID" INTEGER NOT NULL,
  "SalaryDetails" TEXT NOT NULL,
  "OfferStatus" VARCHAR(32) DEFAULT 'Draft' CHECK ("OfferStatus" IN ('Draft','Sent','Accepted','Rejected')),
  "IssuedDate" TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE userrole (
  "RoleID" SERIAL PRIMARY KEY,
  "RoleName" VARCHAR(32) NOT NULL CHECK ("RoleName" IN ('Hiring Manager','Recruiter','Business Ops','Candidate'))
);

INSERT INTO userrole ("RoleID", "RoleName") VALUES
(1, 'Hiring Manager'),
(2, 'Recruiter'),
(3, 'Business Ops'),
(4, 'Candidate');

CREATE TABLE users (
  "UserID" SERIAL PRIMARY KEY,
  "Name" VARCHAR(191) NOT NULL,
  "RoleID" INTEGER NOT NULL,
  "Email" VARCHAR(191) NOT NULL UNIQUE,
  "PasswordHash" VARCHAR(255) NOT NULL
);

INSERT INTO users ("UserID", "Name", "RoleID", "Email", "PasswordHash") VALUES
(1, 'PixelHR', 1, 'pixelhr@gmail.com', 'Admin@123'),
(2, 'PixelREQ', 2, 'pixelreq@gmail.com', 'Admin@123'),
(3, 'PixelBO', 3, 'pixelbo@gmail.com', 'Admin@123'),
(4, 'PixelCan', 4, 'pixelcan@gmail.com', 'Admin@123');
