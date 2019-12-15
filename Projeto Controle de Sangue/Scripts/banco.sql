-- phpMyAdmin SQL Dump
-- version 4.0.10.15
-- http://www.phpmyadmin.net
--
-- Máquina: localhost
-- Data de Criação: 15-Dez-2019 às 12:23
-- Versão do servidor: 5.5.20
-- versão do PHP: 5.3.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Base de Dados: `banco`
--

-- --------------------------------------------------------

--
-- Estrutura da tabela `bolsa`
--

CREATE TABLE IF NOT EXISTS `bolsa` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `numero_da_bolsa` varchar(20) NOT NULL,
  `tipo` varchar(4) NOT NULL,
  `abo` varchar(2) NOT NULL,
  `rh` char(1) NOT NULL,
  `origem` varchar(15) NOT NULL DEFAULT 'HEMOGO',
  `volume` int(11) NOT NULL,
  `pai` char(1) NOT NULL DEFAULT 'N',
  `sifilis` char(1) NOT NULL DEFAULT 'N',
  `chagas` char(1) NOT NULL DEFAULT 'N',
  `hepatiteb` char(1) NOT NULL DEFAULT 'N',
  `hepatitec` char(1) NOT NULL DEFAULT 'N',
  `hiv` char(1) NOT NULL DEFAULT 'N',
  `htlv` char(1) NOT NULL DEFAULT 'N',
  `hemoglobinas` char(1) NOT NULL DEFAULT 'N',
  `data_vencimento` date NOT NULL,
  `volume_atual` int(11) NOT NULL,
  `data_coleta` date NOT NULL,
  `numero_doacoes` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=8 ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `descarte`
--

CREATE TABLE IF NOT EXISTS `descarte` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_bolsa` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `motivo` varchar(100) NOT NULL,
  `volume` int(11) NOT NULL,
  `data_descarte` date NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `fk_descarte_id_bolsa_idx` (`id_bolsa`),
  KEY `fk_descarte_id_usuario_idx` (`id_usuario`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Acionadores `descarte`
--
DROP TRIGGER IF EXISTS `tg_Descarte_After_Delete`;
DELIMITER //
CREATE TRIGGER `tg_Descarte_After_Delete` AFTER DELETE ON `descarte`
 FOR EACH ROW begin
	update bolsa set volume_atual = (volume_atual + old.volume) where id = old.id_bolsa;
end
//
DELIMITER ;
DROP TRIGGER IF EXISTS `tg_Descarte_After_Insert`;
DELIMITER //
CREATE TRIGGER `tg_Descarte_After_Insert` AFTER INSERT ON `descarte`
 FOR EACH ROW begin
	update bolsa set volume_atual = (volume_atual - new.volume) where id = new.id_bolsa;
end
//
DELIMITER ;
DROP TRIGGER IF EXISTS `tg_Descarte_After_Update`;
DELIMITER //
CREATE TRIGGER `tg_Descarte_After_Update` AFTER UPDATE ON `descarte`
 FOR EACH ROW begin
	update bolsa set volume_atual = (volume_atual + old.volume) where id = old.id_bolsa;
    update bolsa set volume_atual = (volume_atual - new.volume) where id = new.id_bolsa;
end
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `endereco`
--

CREATE TABLE IF NOT EXISTS `endereco` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_municipio` int(11) DEFAULT NULL,
  `id_paciente` int(11) NOT NULL,
  `logradouro` varchar(100) DEFAULT NULL,
  `bairro` varchar(100) DEFAULT NULL,
  `complemento` varchar(100) DEFAULT NULL,
  `numero` varchar(8) DEFAULT NULL,
  `cep` varchar(8) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_endereco_id_municipio` (`id_municipio`),
  KEY `fk_endereco_id_paciente` (`id_paciente`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=4 ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `entrada`
--

CREATE TABLE IF NOT EXISTS `entrada` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_usuario` int(11) NOT NULL,
  `data_entrada` date NOT NULL,
  `id_bolsa` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_entrada_id_usuario` (`id_usuario`),
  KEY `fk_entrada_id_bolsa_idx` (`id_bolsa`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=8 ;

--
-- Acionadores `entrada`
--
DROP TRIGGER IF EXISTS `tg_entrada_after_delete`;
DELIMITER //
CREATE TRIGGER `tg_entrada_after_delete` AFTER DELETE ON `entrada`
 FOR EACH ROW BEGIN
 DELETE FROM bolsa where id = old.id_bolsa;
END
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `estado`
--

CREATE TABLE IF NOT EXISTS `estado` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `codigo_uf` int(11) NOT NULL,
  `nome` varchar(50) NOT NULL,
  `uf` char(2) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `codigoUf_UNIQUE` (`codigo_uf`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=28 ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `municipio`
--

CREATE TABLE IF NOT EXISTS `municipio` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_estado` int(11) NOT NULL,
  `codigo_ibge` int(11) NOT NULL,
  `nome` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Codigo_UNIQUE` (`codigo_ibge`),
  KEY `fk_municipio_id_estado` (`id_estado`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=5565 ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `paciente`
--

CREATE TABLE IF NOT EXISTS `paciente` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `nome_pai` varchar(100) DEFAULT NULL,
  `nome_mae` varchar(100) DEFAULT NULL,
  `data_nascimento` date NOT NULL,
  `sexo` char(1) NOT NULL,
  `num_prontuario` varchar(20) DEFAULT NULL,
  `abo` varchar(2) NOT NULL,
  `rh` char(1) NOT NULL,
  `cpf` varchar(11) DEFAULT NULL,
  `rg` varchar(10) DEFAULT NULL,
  `sus` varchar(16) DEFAULT NULL,
  `observacao` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sus_UNIQUE` (`sus`),
  UNIQUE KEY `num_prontuario_UNIQUE` (`num_prontuario`),
  UNIQUE KEY `cpf_UNIQUE` (`cpf`),
  UNIQUE KEY `rg_UNIQUE` (`rg`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=5 ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `procedimento_especial`
--

CREATE TABLE IF NOT EXISTS `procedimento_especial` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_saida` int(11) DEFAULT NULL,
  `id_descarte` int(11) DEFAULT NULL,
  `irradiacao` char(1) NOT NULL,
  `filtracao` char(1) NOT NULL,
  `fracionamento` char(1) NOT NULL,
  `fenotipagem` char(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_proced_especial_id_saida_idx` (`id_saida`),
  KEY `fk_proced_especial_id_descarte_idx` (`id_descarte`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `saida`
--

CREATE TABLE IF NOT EXISTS `saida` (
  `id` int(11) NOT NULL,
  `id_paciente` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `id_bolsa` int(11) NOT NULL,
  `data_saida` date NOT NULL,
  `hospital` varchar(100) NOT NULL DEFAULT 'HMI',
  `pai` char(1) NOT NULL DEFAULT 'N',
  `prova_compatibilidade_ta` char(1) NOT NULL,
  `prova_compatibilidade_agh` char(1) NOT NULL,
  `prova_compatibilidade_37` char(1) NOT NULL,
  `volume` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_saida_id_paciente` (`id_paciente`),
  KEY `fk_saida_id_usuario` (`id_usuario`),
  KEY `fk_saida_id_bolsa` (`id_bolsa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Acionadores `saida`
--
DROP TRIGGER IF EXISTS `tg_Saida_After_Delete`;
DELIMITER //
CREATE TRIGGER `tg_Saida_After_Delete` AFTER DELETE ON `saida`
 FOR EACH ROW begin
	update bolsa set volume_atual = (volume_atual + old.volume) where id = old.id_bolsa;
end
//
DELIMITER ;
DROP TRIGGER IF EXISTS `tg_Saida_After_Insert`;
DELIMITER //
CREATE TRIGGER `tg_Saida_After_Insert` AFTER INSERT ON `saida`
 FOR EACH ROW begin
	update bolsa set volume_atual = (volume_atual - new.volume) where id = new.id_bolsa;
end
//
DELIMITER ;
DROP TRIGGER IF EXISTS `tg_Saida_After_Update`;
DELIMITER //
CREATE TRIGGER `tg_Saida_After_Update` AFTER UPDATE ON `saida`
 FOR EACH ROW begin
	update bolsa set volume_atual = (volume_atual + old.volume) where id = old.id_bolsa;
    update bolsa set volume_atual = (volume_atual - new.volume) where id = new.id_bolsa;
end
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `telefone`
--

CREATE TABLE IF NOT EXISTS `telefone` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_paciente` int(11) NOT NULL,
  `ddd` char(2) NOT NULL,
  `numero` varchar(10) NOT NULL,
  `tipo_telefone` char(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_id_paciente_idx` (`id_paciente`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `usuario`
--

CREATE TABLE IF NOT EXISTS `usuario` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(20) NOT NULL,
  `senha` varchar(80) NOT NULL,
  `admin` char(1) NOT NULL DEFAULT 'N',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Constraints for dumped tables
--

--
-- Limitadores para a tabela `descarte`
--
ALTER TABLE `descarte`
  ADD CONSTRAINT `fk_descarte_id_bolsa` FOREIGN KEY (`id_bolsa`) REFERENCES `bolsa` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_descarte_id_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Limitadores para a tabela `endereco`
--
ALTER TABLE `endereco`
  ADD CONSTRAINT `fk_endereco_id_municipio` FOREIGN KEY (`id_municipio`) REFERENCES `municipio` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_endereco_id_paciente` FOREIGN KEY (`id_paciente`) REFERENCES `paciente` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION;

--
-- Limitadores para a tabela `entrada`
--
ALTER TABLE `entrada`
  ADD CONSTRAINT `fk_entrada_id_bolsa` FOREIGN KEY (`id_bolsa`) REFERENCES `bolsa` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_entrada_id_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Limitadores para a tabela `municipio`
--
ALTER TABLE `municipio`
  ADD CONSTRAINT `fk_municipio_id_estado` FOREIGN KEY (`id_estado`) REFERENCES `estado` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Limitadores para a tabela `procedimento_especial`
--
ALTER TABLE `procedimento_especial`
  ADD CONSTRAINT `fk_proced_especial_id_descarte` FOREIGN KEY (`id_descarte`) REFERENCES `descarte` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_proced_especial_id_saida` FOREIGN KEY (`id_saida`) REFERENCES `saida` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION;

--
-- Limitadores para a tabela `saida`
--
ALTER TABLE `saida`
  ADD CONSTRAINT `fk_saida_id_bolsa` FOREIGN KEY (`id_bolsa`) REFERENCES `bolsa` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_saida_id_paciente` FOREIGN KEY (`id_paciente`) REFERENCES `paciente` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_saida_id_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Limitadores para a tabela `telefone`
--
ALTER TABLE `telefone`
  ADD CONSTRAINT `fk_id_paciente` FOREIGN KEY (`id_paciente`) REFERENCES `paciente` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
