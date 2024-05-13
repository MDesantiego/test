-- phpMyAdmin SQL Dump
-- version 3.5.1
-- http://www.phpmyadmin.net
--
-- Хост: 127.0.0.1
-- Время создания: Май 13 2024 г., 22:23
-- Версия сервера: 5.5.25
-- Версия PHP: 5.3.13

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- База данных: `test`
--

-- --------------------------------------------------------

--
-- Структура таблицы `attached`
--

CREATE TABLE IF NOT EXISTS `attached` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userid` int(11) NOT NULL,
  `attachSlot` int(11) NOT NULL,
  `attachBoneid` int(11) NOT NULL,
  `attachModel` int(11) NOT NULL,
  `attachX` float NOT NULL,
  `attachY` float NOT NULL,
  `attachZ` float NOT NULL,
  `attachRX` float NOT NULL,
  `attachRY` float NOT NULL,
  `attachRZ` float NOT NULL,
  `aindex` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Дамп данных таблицы `attached`
--

INSERT INTO `attached` (`id`, `userid`, `attachSlot`, `attachBoneid`, `attachModel`, `attachX`, `attachY`, `attachZ`, `attachRX`, `attachRY`, `attachRZ`, `aindex`) VALUES
(1, 1, 0, 2, 355, 0, -0.305999, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `items`
--

CREATE TABLE IF NOT EXISTS `items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `itemName` varchar(32) NOT NULL,
  `itemModel` int(11) NOT NULL,
  `itemBone` int(11) NOT NULL,
  `itemX` float NOT NULL,
  `itemY` float NOT NULL,
  `itemZ` float NOT NULL,
  `itemRotX` float NOT NULL,
  `itemRotY` float NOT NULL,
  `itemRotZ` float NOT NULL,
  `itemIndex` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Дамп данных таблицы `items`
--

INSERT INTO `items` (`id`, `itemName`, `itemModel`, `itemBone`, `itemX`, `itemY`, `itemZ`, `itemRotX`, `itemRotY`, `itemRotZ`, `itemIndex`) VALUES
(1, 'Fovw', 355, 2, 0, -0.305999, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `player`
--

CREATE TABLE IF NOT EXISTS `player` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(32) NOT NULL,
  `i0` int(11) NOT NULL DEFAULT '0',
  `i1` int(11) NOT NULL DEFAULT '0',
  `i2` int(11) NOT NULL DEFAULT '0',
  `i3` int(11) NOT NULL DEFAULT '0',
  `i4` int(11) NOT NULL DEFAULT '0',
  `i5` int(11) NOT NULL DEFAULT '0',
  `i6` int(11) NOT NULL DEFAULT '0',
  `i7` int(11) NOT NULL DEFAULT '0',
  `i8` int(11) NOT NULL DEFAULT '0',
  `a0` int(11) NOT NULL DEFAULT '0',
  `a1` int(11) NOT NULL DEFAULT '0',
  `a2` int(11) NOT NULL DEFAULT '0',
  `a3` int(11) NOT NULL DEFAULT '0',
  `a4` int(11) NOT NULL DEFAULT '0',
  `a5` int(11) NOT NULL DEFAULT '0',
  `a6` int(11) NOT NULL DEFAULT '0',
  `a7` int(11) NOT NULL DEFAULT '0',
  `a8` int(11) NOT NULL DEFAULT '0',
  `use0` tinyint(1) NOT NULL DEFAULT '0',
  `use1` tinyint(1) NOT NULL DEFAULT '0',
  `use2` tinyint(1) NOT NULL DEFAULT '0',
  `use3` tinyint(1) NOT NULL DEFAULT '0',
  `use4` tinyint(1) NOT NULL DEFAULT '0',
  `use5` tinyint(1) NOT NULL DEFAULT '0',
  `use6` tinyint(1) NOT NULL DEFAULT '0',
  `use7` tinyint(1) NOT NULL DEFAULT '0',
  `use8` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Дамп данных таблицы `player`
--

INSERT INTO `player` (`id`, `username`, `i0`, `i1`, `i2`, `i3`, `i4`, `i5`, `i6`, `i7`, `i8`, `a0`, `a1`, `a2`, `a3`, `a4`, `a5`, `a6`, `a7`, `a8`, `use0`, `use1`, `use2`, `use3`, `use4`, `use5`, `use6`, `use7`, `use8`) VALUES
(1, 'Moretti', 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
