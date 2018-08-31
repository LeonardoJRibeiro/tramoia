-- phpMyAdmin SQL Dump
-- version 4.6.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: 30-Ago-2018 às 21:07
-- Versão do servidor: 5.7.14
-- PHP Version: 5.6.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `banco`
--

-- --------------------------------------------------------

--
-- Estrutura da tabela `bolsa`
--

CREATE TABLE `bolsa` (
  `id` int(11) NOT NULL,
  `numero_da_bolsa` varchar(20) NOT NULL,
  `tipo` varchar(3) NOT NULL,
  `abo` varchar(2) NOT NULL,
  `rh` char(1) NOT NULL,
  `origem` varchar(15) NOT NULL DEFAULT 'HEMOGO',
  `volume` int(11) NOT NULL,
  `sorologia` char(1) NOT NULL DEFAULT 'N',
  `possui_estoque` char(1) NOT NULL DEFAULT 'S'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `bolsa`
--

INSERT INTO `bolsa` (`id`, `numero_da_bolsa`, `tipo`, `abo`, `rh`, `origem`, `volume`, `sorologia`, `possui_estoque`) VALUES
(1, '1', 'ch', 'b', '+', 'hemogo', 350, 'N', 'N'),
(2, '2', 'ch', 'b', '+', 'HEMOGO', 340, 'N', 'S'),
(3, '3', 'ch', 'b', '+', 'HEMOGO', 330, 'N', 'S'),
(4, '4', 'ch', 'b', '+', 'HEMOGO', 320, 'N', 'S'),
(5, '5', 'CH', 'B', '+', 'HEMOGO', 400, 'N', 'S');

-- --------------------------------------------------------

--
-- Estrutura da tabela `endereco`
--

CREATE TABLE `endereco` (
  `id` int(11) NOT NULL,
  `id_municipio` int(11) NOT NULL,
  `id_paciente` int(11) NOT NULL,
  `logradouro` varchar(100) NOT NULL,
  `bairro` varchar(100) NOT NULL,
  `complemento` varchar(100) DEFAULT NULL,
  `numero` varchar(8) DEFAULT NULL,
  `cep` varchar(8) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `entrada`
--

CREATE TABLE `entrada` (
  `id` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `id_bolsa` int(11) NOT NULL,
  `data_entrada` date NOT NULL,
  `observacao` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `entrada`
--

INSERT INTO `entrada` (`id`, `id_usuario`, `id_bolsa`, `data_entrada`, `observacao`) VALUES
(1, 1, 5, '2018-08-30', NULL);

-- --------------------------------------------------------

--
-- Estrutura da tabela `estado`
--

CREATE TABLE `estado` (
  `id` int(11) NOT NULL,
  `codigo_uf` int(11) NOT NULL,
  `nome` varchar(50) NOT NULL,
  `uf` char(2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `municipio`
--

CREATE TABLE `municipio` (
  `id` int(11) NOT NULL,
  `id_estado` int(11) NOT NULL,
  `codigo_ibge` int(11) NOT NULL,
  `nome` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `paciente`
--

CREATE TABLE `paciente` (
  `id` int(11) NOT NULL,
  `nome` varchar(100) NOT NULL,
  `nome_pai` varchar(100) DEFAULT NULL,
  `nome_mae` varchar(100) DEFAULT NULL,
  `data_nascimento` date NOT NULL,
  `sexo` char(1) NOT NULL,
  `num_prontuario` varchar(20) NOT NULL,
  `abo` varchar(2) NOT NULL,
  `rh` char(1) NOT NULL,
  `cpf` varchar(11) DEFAULT NULL,
  `rg` varchar(10) DEFAULT NULL,
  `telefone` varchar(12) DEFAULT NULL,
  `sus` varchar(16) NOT NULL,
  `observacao` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `paciente`
--

INSERT INTO `paciente` (`id`, `nome`, `nome_pai`, `nome_mae`, `data_nascimento`, `sexo`, `num_prontuario`, `abo`, `rh`, `cpf`, `rg`, `telefone`, `sus`, `observacao`) VALUES
(1, 'alexandre', 'adenilton', 'marlene', '1998-06-12', 'm', '01234567890', 'B', '+', '70033041121', '5614173', '62985343128', '1', 'muito lindo'),
(2, 'joao vinicius', 'joao', 'ilza', '1998-02-18', 'm', '01234567891', 'b', '+', NULL, NULL, NULL, '2', 'muito veadinho'),
(3, 'danilo pinheiro', NULL, NULL, '1992-06-19', 'm', '01234567892', 'b', '+', NULL, NULL, NULL, '3', 'muito galã');

-- --------------------------------------------------------

--
-- Estrutura da tabela `saida`
--

CREATE TABLE `saida` (
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
  `responsavel` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `saida`
--

INSERT INTO `saida` (`id`, `id_paciente`, `id_usuario`, `id_bolsa`, `data_saida`, `hospital`, `pai`, `prova_compatibilidade_ta`, `prova_compatibilidade_agh`, `prova_compatibilidade_37`, `responsavel`) VALUES
(1, 1, 1, 1, '2018-08-30', 'HMI', 'N', 'N', 'N', 'N', 'ALEXANDRE');

--
-- Acionadores `saida`
--
DELIMITER $$
CREATE TRIGGER `tg_Saida_After_Delete` AFTER DELETE ON `saida` FOR EACH ROW begin
	update `banco`.`bolsa` set `banco`.`bolsa`.`possui_estoque` = 'S' where `banco`.`bolsa`.`id` = old.id_bolsa;
end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tg_Saida_After_Insert` AFTER INSERT ON `saida` FOR EACH ROW begin
	update `banco`.`bolsa` set `banco`.`bolsa`.`possui_estoque` = 'N' where `banco`.`bolsa`.`id` = new.id_bolsa;
end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tg_Saida_After_Update` AFTER UPDATE ON `saida` FOR EACH ROW begin
	update `banco`.`bolsa` set `banco`.`bolsa`.`possui_estoque` = 'S' where `banco`.`bolsa`.`id` = old.id_bolsa;
    update `banco`.`bolsa` set `banco`.`bolsa`.`possui_estoque` = 'N' where `banco`.`bolsa`.`id` = new.id_bolsa;
end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `usuario`
--

CREATE TABLE `usuario` (
  `id` int(11) NOT NULL,
  `nome` varchar(20) NOT NULL,
  `senha` varchar(20) NOT NULL,
  `admin` char(1) NOT NULL DEFAULT 'N'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `usuario`
--

INSERT INTO `usuario` (`id`, `nome`, `senha`, `admin`) VALUES
(1, 'admin', '9D979C9E', 'S');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `bolsa`
--
ALTER TABLE `bolsa`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `numero_bolsa_UNIQUE` (`numero_da_bolsa`);

--
-- Indexes for table `endereco`
--
ALTER TABLE `endereco`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_endereco_id_municipio` (`id_municipio`),
  ADD KEY `fk_endereco_id_paciente` (`id_paciente`);

--
-- Indexes for table `entrada`
--
ALTER TABLE `entrada`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id_bolsa_UNIQUE` (`id_bolsa`),
  ADD KEY `fk_entrada_id_usuario` (`id_usuario`),
  ADD KEY `fk_entrada_id_bolsa` (`id_bolsa`);

--
-- Indexes for table `estado`
--
ALTER TABLE `estado`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `codigoUf_UNIQUE` (`codigo_uf`);

--
-- Indexes for table `municipio`
--
ALTER TABLE `municipio`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `Codigo_UNIQUE` (`codigo_ibge`),
  ADD KEY `fk_municipio_id_estado` (`id_estado`);

--
-- Indexes for table `paciente`
--
ALTER TABLE `paciente`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `sus_UNIQUE` (`sus`),
  ADD UNIQUE KEY `num_prontuario_UNIQUE` (`num_prontuario`),
  ADD UNIQUE KEY `cpf_UNIQUE` (`cpf`),
  ADD UNIQUE KEY `rg_UNIQUE` (`rg`);

--
-- Indexes for table `saida`
--
ALTER TABLE `saida`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id_bolsa_UNIQUE` (`id_bolsa`),
  ADD KEY `fk_saida_id_paciente` (`id_paciente`),
  ADD KEY `fk_saida_id_usuario` (`id_usuario`),
  ADD KEY `fk_saida_id_bolsa` (`id_bolsa`);

--
-- Indexes for table `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `bolsa`
--
ALTER TABLE `bolsa`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT for table `endereco`
--
ALTER TABLE `endereco`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `entrada`
--
ALTER TABLE `entrada`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `estado`
--
ALTER TABLE `estado`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `municipio`
--
ALTER TABLE `municipio`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `paciente`
--
ALTER TABLE `paciente`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT for table `usuario`
--
ALTER TABLE `usuario`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- Constraints for dumped tables
--

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
  ADD CONSTRAINT `fk_entrada_id_bolsa` FOREIGN KEY (`id_bolsa`) REFERENCES `bolsa` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_entrada_id_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Limitadores para a tabela `municipio`
--
ALTER TABLE `municipio`
  ADD CONSTRAINT `fk_municipio_id_estado` FOREIGN KEY (`id_estado`) REFERENCES `estado` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Limitadores para a tabela `saida`
--
ALTER TABLE `saida`
  ADD CONSTRAINT `fk_saida_id_bolsa` FOREIGN KEY (`id_bolsa`) REFERENCES `bolsa` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_saida_id_paciente` FOREIGN KEY (`id_paciente`) REFERENCES `paciente` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_saida_id_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
