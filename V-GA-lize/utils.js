function getFillStyle(minScore,score,maxScore)
{
    if (score >= minScore)
    {
        return rgb(minScore, maxScore, score)
    }

    return Qt.rgba(0.0, 0.0, 0.0, 0.0)
}


function getGeneStyle(gen, clus, ind, gene)
{
    var val = gaviz.getGene(gen, clus, ind, gene)
    var maxval = gaviz.getGeneMax()
    var minval = gaviz.getGeneMin()

    var col = rgb(minval, maxval, val)

    return col
}

function rgb(minimum, maximum, value)
{
    var ratio = 2 * (value-minimum) / (maximum - minimum)
    var b = Math.max(0, 255*(1 - ratio))
    var r = Math.max(0, 255*(ratio - 1))
    var g = 255 - b - r

    return Qt.rgba(r/255.0, g/255.0, b/255.0, 1)
}


