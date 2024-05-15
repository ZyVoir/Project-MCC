-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 17, 2023 at 03:16 PM
-- Server version: 10.4.19-MariaDB
-- PHP Version: 8.0.7

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `flokemon`
--

-- --------------------------------------------------------

--
-- Table structure for table `mspokemon`
--

CREATE TABLE `mspokemon` (
  `PokemonID` int(11) NOT NULL,
  `PokemonName` varchar(255) NOT NULL,
  `PokemonImage_Link` varchar(255) NOT NULL,
  `PokemonType_Primary` varchar(15) NOT NULL,
  `PokemonType_Secondary` varchar(15) DEFAULT NULL,
  `PokemonDescription` varchar(512) NOT NULL,
  `PokemonHeight_ft` int(11) NOT NULL,
  `PokemonHeight_in` int(11) NOT NULL,
  `PokemonWeight_lbs` int(11) NOT NULL,
  `PokemonPrice_Dollar` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `mspokemon`
--

INSERT INTO `mspokemon` (`PokemonID`, `PokemonName`, `PokemonImage_Link`, `PokemonType_Primary`, `PokemonType_Secondary`, `PokemonDescription`, `PokemonHeight_ft`, `PokemonHeight_in`, `PokemonWeight_lbs`, `PokemonPrice_Dollar`) VALUES
(1, 'Pikachu', 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/025.png', 'Electric', NULL, 'Pikachu created by INGEN to challenge the Tyranosaurus Rex', 4, 10, 30, 999),
(2, 'Bulbasaur', 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/001.png', 'Grass', NULL, 'There is a plant seed on its back right from the day this Pokémon is born. The seed slowly grows larger.', 2, 4, 15, 100),
(3, 'BeeDrill', 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/015.png', 'Poison', NULL, 'It has three poisonous stingers on its forelegs and its tail. They are used to jab its enemy repeatedly.', 3, 3, 65, 70),
(4, 'Onix', 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/095.png', 'Rock', NULL, 'As it digs through the ground, it absorbs many hard objects. This is what makes its body so solid.', 28, 10, 463, 500),
(5, 'DugTrio', 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/051.png', 'Ground', NULL, 'Its three heads bob separately up and down to loosen the soil nearby, making it easier for it to burrow.', 2, 4, 73, 120),
(6, 'Charizard', 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/006.png', 'Fire', 'Flying', 'It is said that Charizard’s fire burns hotter if it has experienced harsh battles.', 5, 7, 199, 179),
(337, 'Lunatone ', 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/337.png', 'Rock', 'Psychic', 'The phase of the moon apparently has some effect on its power. It’s active on the night of a full moon.', 3, 3, 370, 150),
(395, 'Empoleon ', 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/395.png', 'Water', 'Steel', 'It swims as fast as a jet boat. The edges of its wings are sharp and can slice apart drifting ice.', 5, 7, 186, 750),
(473, 'Mamoswine ', 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/473.png', 'Ice', 'Ground', 'This Pokémon can be spotted in wall paintings from as far back as 10,000 years ago. For a while, it was thought to have gone extinct.\n\n', 8, 2, 641, 150),
(644, 'Zekrom ', 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/644.png', 'Dragon', 'Electric', 'This legendary Pokémon can scorch the world with lightning. It assists those who want to build an ideal world.\n\n', 9, 6, 760, 10000),
(724, 'Decidueye ', 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/724.png', 'Grass', 'Ghost', 'It fires arrow quills from its wings with such precision, they can pierce a pebble at distances over a hundred yards.', 5, 3, 80, 100),
(920, 'Lokix ', 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/920.png', 'Bug', 'Dark', 'When it decides to fight all out, it stands on its previously folded legs to enter Showdown Mode. It neutralizes its enemies in short order.\n\n', 3, 3, 38, 10),
(944, 'Shroodle', 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/944.png', 'Poison', 'Normal', 'Though usually a mellow Pokémon, it will sink its sharp, poison-soaked front teeth into any that anger it, causing paralysis in the object of its ire.', 1, 8, 1, 15),
(1006, 'Iron Valiant', 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/1006.png', 'Fairy', 'Fighting', 'It has some similarities to a mad scientist’s invention covered in a paranormal magazine.\n\n', 4, 7, 77, 100);

-- --------------------------------------------------------

--
-- Table structure for table `mstransaction`
--

CREATE TABLE `mstransaction` (
  `TransactionID` int(11) NOT NULL,
  `Email` varchar(255) DEFAULT NULL,
  `PokemonID` int(11) DEFAULT NULL,
  `PokemonQuantity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `msuser`
--

CREATE TABLE `msuser` (
  `Email` varchar(255) NOT NULL,
  `Username` varchar(255) NOT NULL,
  `Userpassword` varchar(255) DEFAULT NULL,
  `token` varchar(10) NOT NULL,
  `role` enum('user','admin','userGoogle') NOT NULL DEFAULT 'user'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `msuser`
--

INSERT INTO `msuser` (`Email`, `Username`, `Userpassword`, `token`, `role`) VALUES
('admin@gmail.com', 'Administrator', 'admin', 'adminadmin', 'admin'),
('Ash123@gmail.com', 'AshKetchum1', 'Ashketchum123', 'dTam9Jls7v', 'user');

-- --------------------------------------------------------

--
-- Table structure for table `mswishlist`
--

CREATE TABLE `mswishlist` (
  `Email` varchar(255) NOT NULL,
  `PokemonID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_ownedpokemon`
-- (See below for the actual view)
--
CREATE TABLE `view_ownedpokemon` (
`Email` varchar(255)
,`token` varchar(10)
,`PokemonID` int(11)
,`OwnedPokemon` decimal(32,0)
);

-- --------------------------------------------------------

--
-- Structure for view `view_ownedpokemon`
--
DROP TABLE IF EXISTS `view_ownedpokemon`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_ownedpokemon`  AS SELECT `mt`.`Email` AS `Email`, `mu`.`token` AS `token`, `mt`.`PokemonID` AS `PokemonID`, sum(`mt`.`PokemonQuantity`) AS `OwnedPokemon` FROM (`mstransaction` `mt` join `msuser` `mu` on(`mu`.`Email` = `mt`.`Email`)) GROUP BY `mu`.`Email`, `mt`.`PokemonID` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `mspokemon`
--
ALTER TABLE `mspokemon`
  ADD PRIMARY KEY (`PokemonID`);

--
-- Indexes for table `mstransaction`
--
ALTER TABLE `mstransaction`
  ADD PRIMARY KEY (`TransactionID`),
  ADD KEY `Email` (`Email`),
  ADD KEY `PokemonID` (`PokemonID`);

--
-- Indexes for table `msuser`
--
ALTER TABLE `msuser`
  ADD PRIMARY KEY (`Email`);

--
-- Indexes for table `mswishlist`
--
ALTER TABLE `mswishlist`
  ADD PRIMARY KEY (`Email`,`PokemonID`),
  ADD KEY `PokemonID` (`PokemonID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `mstransaction`
--
ALTER TABLE `mstransaction`
  MODIFY `TransactionID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=47;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `mstransaction`
--
ALTER TABLE `mstransaction`
  ADD CONSTRAINT `mstransaction_ibfk_1` FOREIGN KEY (`Email`) REFERENCES `msuser` (`Email`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `mstransaction_ibfk_2` FOREIGN KEY (`PokemonID`) REFERENCES `mspokemon` (`PokemonID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `mswishlist`
--
ALTER TABLE `mswishlist`
  ADD CONSTRAINT `mswishlist_ibfk_1` FOREIGN KEY (`PokemonID`) REFERENCES `mspokemon` (`PokemonID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `mswishlist_ibfk_2` FOREIGN KEY (`Email`) REFERENCES `msuser` (`Email`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
